const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onDocumentCreated, onDocumentUpdated, onDocumentWritten} = require("firebase-functions/v2/firestore");

admin.initializeApp();

const db = admin.firestore();
const axios = require("axios");

const GHN_TOKEN = "1f1b3a6d-33c4-11f1-a973-aee5264794df";
const GHN_SHOP_ID = "199906"; 

function mapStatus(status) {
  switch (status) {
    case "ready_to_pick": return "Chờ lấy hàng";
    case "picking": return "Đang lấy hàng";
    case "picked": return "Đã lấy hàng";
    case "transporting": return "Đang vận chuyển";
    case "delivering": return "Đang giao hàng";
    case "delivered": return "Đã giao";
    case "cancel": return "Đã huỷ";
    default: return status;
  }
}
// 1. Webhook Sepay
exports.sepayWebhook = functions.https.onRequest(async (req, res) => {
  if (req.method !== 'POST') {
    return res.status(405).send('Method Not Allowed');
  }

  try {
    const data = req.body || {};
    console.log("Webhook nhận được đầy đủ:", JSON.stringify(data));

    const amount = Number(data.amount || data.transferAmount || 0);
    let orderId = (data.description || data.content || data.transaction_content || "").trim();

    const match = orderId.match(/(ORDER\d+)/i);
    if (match) orderId = match[1];

    if (amount <= 0 || !orderId) {
      console.log("Thiếu amount hoặc orderId", { amount, orderId });
      return res.status(400).send("Thiếu amount hoặc orderId");
    }

    console.log("Parsed: OrderId =", orderId, "| Amount =", amount);

    // Bước 1: Tìm mapping từ orderId để lấy userId
    const mappingRef = db.collection("OrderIds").doc(orderId);
    const mappingDoc = await mappingRef.get();

    if (!mappingDoc.exists) {
      console.log("Không tìm thấy mapping cho order:", orderId);
      return res.status(200).send("Order mapping not found");
    }

    const mappingData = mappingDoc.data();
    const userId = mappingData.userId;

    if (!userId) {
      console.log("Mapping thiếu userId cho order:", orderId);
      return res.status(200).send("Invalid mapping");
    }

    // Bước 2: Lấy document order thực tế
    const orderRef = db.collection("Users").doc(userId).collection("Orders").doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      console.log("Không tìm thấy order thực tế:", orderId);
      return res.status(200).send("Order not found");
    }

    const orderData = orderDoc.data();
    const orderAmount = Number(orderData.totalAmount || 0);

    if (Math.abs(amount - orderAmount) > 1000) {
      console.log("Số tiền không khớp", { order: orderAmount, received: amount });
      return res.status(200).send("Amount mismatch");
    }

    if (orderData.status === "paid" || orderData.paymentVerified === true) {
      console.log("Đã xử lý trước đó:", orderId);
      return res.status(200).send("Already processed");
    }

    // Update order
    await orderRef.update({
      status: "paid",
      paymentVerified: true,
      paidAt: admin.firestore.FieldValue.serverTimestamp(),
      paymentMethod: "bank_transfer",
    });

    console.log("🎉 Thành công: Paid order", orderId, "User:", userId);
    return res.status(200).send("OK");

  } catch (error) {
    console.error("Lỗi webhook:", error.stack || error.message);
    return res.status(500).send("Internal Server Error: " + (error.message || 'Unknown error'));
  }
}
);
// 2. Tự động huỷ đơn hàng pending sau expireAt (trigger khi tạo order)
exports.autoCancelExpiredOrders = onDocumentCreated(
  'Users/{userId}/Orders/{orderId}',
  async (event) => {
    const snap = event.data;
    if (!snap) return;

    const data = snap.data();

    // Chỉ xử lý nếu là pending và có expireAt
    if (data.status !== 'pending' || !data.expireAt) {
      return;
    }

    const createdAt = data.createdAt?.toDate();
      if (!createdAt) return;

      const expireAt = new Date(createdAt.getTime() + 60 * 1000); // 1 phút
      const now = new Date();
      const delayMs = expireAt.getTime() - now.getTime();

    if (delayMs <= 0) {
      // Đã hết hạn ngay khi tạo
      await snap.ref.update({
        status: 'cancelled',
        cancelReason: 'Hết thời gian thanh toán',
        cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // await db.collection('OrderIds').doc(event.params.orderId).delete();

      console.log(`Đơn hàng ${event.params.orderId} đã huỷ ngay khi tạo (hết hạn)`);
      return;
    }

    // Lên lịch huỷ (setTimeout)
    setTimeout(async () => {
      try {
        const currentSnap = await snap.ref.get();
        if (currentSnap.exists && currentSnap.data().status === 'pending') {
          await snap.ref.update({
            status: 'cancelled',
            cancelReason: 'Hết thời gian thanh toán (server)',
            cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
          });

          // await db.collection('OrderIds').doc(event.params.orderId).delete();

          console.log(`Đơn hàng ${event.params.orderId} đã tự động huỷ do hết hạn`);
        }
      } catch (err) {
        console.error("Lỗi khi huỷ đơn hết hạn:", err);
      }
    }, delayMs);
  }
);

exports.syncGHNOrder = functions.https.onRequest(async (req, res) => {
  try {
    const { order_code, userId, orderId } = req.body;

    if (!order_code || !userId || !orderId) {
      return res.status(400).send("Missing order_code, userId, or orderId");
    }

    // ================= FAKE TIMELINE TỪ HCM → CẦN THƠ =================
    const now = Date.now();  

    const fakeTimeline = [
      {
        status: "delivered",
        title: "Đã giao hàng thành công",
        time: new Date(now - 10 * 60 * 1000),
      },
      {
        status: "delivering",
        title: "Đang giao hàng tại Cần Thơ",
        time: new Date(now - 30 * 60 * 1000),
      },
      {
        status: "sorting",
        title: "Đang trung chuyển tại kho Cần Thơ",
        time: new Date(now - 2 * 60 * 60 * 1000),
      },
      {
        status: "transporting",
        title: "Đang vận chuyển từ TP.HCM",
        time: new Date(now - 5 * 60 * 60 * 1000),
      },
      {
        status: "picked",
        title: "Đã lấy hàng",
        time: new Date(now - 7 * 60 * 60 * 1000),
      },
      {
        status: "ready_to_pick",
        title: "Chờ lấy hàng",
        time: new Date(now - 10 * 60 * 60 * 1000),
      },
    ];

    const lastStatus = "delivered";  

    const orderRef = db
      .collection("Users").doc(userId)
      .collection("Orders").doc(orderId);

    await orderRef.update({
      timeline: fakeTimeline,
      ghnStatus: lastStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Fake timeline HCM → Cần Thơ cho order ${orderId}`);

    return res.json({
      success: true,
      ghnStatus: lastStatus,
      timeline: fakeTimeline,
    });

  } catch (error) {
    console.error("❌ syncGHNOrder error:", error);
    return res.status(500).send(error.toString());
  }
});
exports.createGHNOrder = functions.https.onRequest(async (req, res) => {
  try {
    const { orderId, userId } = req.body;

    const orderRef = db.collection("Users").doc(userId).collection("Orders").doc(orderId);
    const orderDoc = await orderRef.get();

    if (!orderDoc.exists) {
      return res.status(404).send("Order not found");
    }

    const order = orderDoc.data();

    /// TRÁNH TẠO 2 LẦN
    if (order.ghnCode) {
      return res.json({ ghnOrderCode: order.ghnCode });
    }

    /// CALL GHN CREATE
    const ghnRes = await axios.post(
      "https://dev-online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/create",
      {
        payment_type_id: 2,
        note: "Shop App Order",
        required_note: "KHONGCHOXEMHANG",

        /// FROM (shop)
        from_name: "Shop App",
        from_phone: "0900000000",
        from_address: "Cần Thơ",
        from_district_id: 1493,
        from_ward_code: "1A0710",

        /// TO (user)
        to_name: order.address?.Name || "Khách",
        to_phone: order.address?.PhoneNumber || "0000000000",
        to_address: order.address?.Street || "",

        to_district_id: order.address?.districtId || 1493,  
        to_ward_code: order.address?.wardCode || "1A0710",  

        cod_amount: Math.round(order.totalAmount || 0),

        weight: 200,
        length: 10,
        width: 10,
        height: 10,

        service_type_id: 2,

        items: order.items.map(i => ({
          name: i.title,
          quantity: i.quantity,
          weight: 200,
        })),
      },
      {
        headers: {
          Token: GHN_TOKEN,
          ShopId: GHN_SHOP_ID,
          "Content-Type": "application/json",
        },
      }
    );

    const ghnOrderCode = ghnRes.data.data.order_code;

    /// SAVE GHN CODE
    await orderRef.update({
      ghnCode: ghnOrderCode,
      shippingProvider: "GHN",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log("🚚 GHN order created:", ghnOrderCode);

    return res.json({ ghnOrderCode });

  } catch (e) {
    console.error("❌ GHN create error:", e.response?.data || e.message);
    return res.status(500).send(e.toString());
  }
});
// ════════════════════════════════════════════════════════════
// HELPER: Gửi FCM + lưu Notification document
// ════════════════════════════════════════════════════════════
 
async function sendNotification({ userId, type, subtype, title, body, image, data }) {
  try {
    const userDoc = await db.collection("Users").doc(userId).get();
    if (!userDoc.exists) return;
 
    const fcmToken = userDoc.data().fcmToken;
 
    // Lưu vào Firestore
    await db.collection("Notifications").add({
      userId,
      type,
      subtype: subtype || null,
      title,
      body,
      image: image || null,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      data: data || {},
    });
 
    // Gửi push nếu có token
    if (fcmToken) {
      await admin.messaging().send({
        token: fcmToken,
        notification: { title, body },
        data: {
          type,
          subtype: subtype || "",
          ...Object.fromEntries(
            Object.entries(data || {}).map(([k, v]) => [k, String(v)])
          ),
        },
        android: {
          notification: { channelId: type === "order" ? "order_channel" : type === "chat" ? "chat_channel" : type === "promo" ? "promo_channel" : "general_channel" },
          priority: "high",
        },
        apns: {
          payload: { aps: { badge: 1, sound: "default" } },
        },
      });
      console.log(`[FCM] Sent to ${userId}: ${title}`);
    }
  } catch (err) {
    console.error("[sendNotification] Error:", err);
  }
}
 
// ════════════════════════════════════════════════════════════
// 5. NOTIFICATION: Đơn hàng đổi trạng thái
// ════════════════════════════════════════════════════════════
 
exports.onOrderStatusChange = onDocumentWritten(
  "Users/{userId}/Orders/{orderId}",
  async (event) => {
    const before = event.data?.before?.data();
    const after  = event.data?.after?.data();
    const { userId, orderId } = event.params;
 
    if (!after) return;
    if (before?.status === after.status) return;
 
    // ── Thông tin sản phẩm ──
    const items        = after.items || [];
    const firstItem    = items[0];
    const productName  = firstItem?.title || firstItem?.name || "sản phẩm";
    const productImage = firstItem?.image || firstItem?.thumbnail || null;
    const itemText     = items.length > 1
      ? `${productName} và ${items.length - 1} sản phẩm khác`
      : productName;
 
    // ── Mã đơn hàng ──
    const shortId = orderId;
 
    const statusMap = {
      confirmed: {
        subtype: "placed",
        title: "🛍️ Đơn hàng đã được xác nhận",
        body: `${shortId} • ${itemText}`,
      },
      paid: {
        subtype: "confirmed",
        title: "✅ Thanh toán thành công",
        body: `${shortId} • ${itemText} - Shop đang chuẩn bị hàng`,
      },
      shipping: {
        subtype: "shipping",
        title: "🚚 Đơn hàng đang giao",
        body: `${shortId} • ${itemText} đang trên đường đến bạn`,
      },
      delivered: {
        subtype: "delivered",
        title: "✅ Giao hàng thành công",
        body: `${shortId} • ${itemText} đã được giao. Hãy đánh giá nhé!`,
      },
      cancelled: {
        subtype: "failed",
        title: "❌ Đơn hàng đã huỷ",
        body: `${shortId} • ${after.cancelReason || "Đơn hàng đã bị huỷ"}`,
      },
      returned: {
        subtype: "returned",
        title: "🔁 Hoàn trả đơn hàng",
        body: `${shortId} • ${itemText} đang được hoàn trả về shop`,
      },
      refunded: {
        subtype: "refunded",
        title: "💸 Hoàn tiền thành công",
        body: `${shortId} • Tiền hoàn trả đã về tài khoản của bạn`,
      },
    };
 
    const noti = statusMap[after.status];
    if (!noti) return;
 
    await sendNotification({
      userId,
      type: "order",
      ...noti,
      image: productImage,
      data: { orderId },
    });
  }
);
 
// ════════════════════════════════════════════════════════════
// 6. NOTIFICATION: Nhắc đánh giá sau khi giao hàng
// ════════════════════════════════════════════════════════════
 
exports.onOrderDelivered = onDocumentUpdated(
  "Users/{userId}/Orders/{orderId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    const { userId, orderId } = event.params;
 
    if (before.status === "delivered" || after.status !== "delivered") return;
 
    const items = after.items || [];
    await sendNotification({
      userId,
      type: "review",
      subtype: "remind",
      title: "⭐ Đánh giá sản phẩm",
      body: "Bạn đã nhận được hàng. Hãy chia sẻ trải nghiệm của bạn nhé!",
      data: { orderId, productId: items[0]?.productId || "" },
    });
  }
);
 
// ════════════════════════════════════════════════════════════
// 7. NOTIFICATION: Coupon mới
// ════════════════════════════════════════════════════════════
 
exports.onNewCoupon = onDocumentCreated("Coupons/{couponId}", async (event) => {
  const coupon = event.data.data();
  const { couponId } = event.params;
  if (!coupon.isActive) return;

  // ── Đúng field name theo Firestore ──
  const code      = coupon.code  || '';
  const value     = coupon.value || 0;
  const type      = coupon.type  || '';          
  const minOrder  = coupon.minOrder  || 0;
  const maxDiscount = coupon.maxDiscount || 0;

  // Build nội dung body
  let discountText = '';
  if (type === 'percentage') {
    discountText = `Giảm ${value}% - Tối đa ${Number(maxDiscount).toLocaleString('vi-VN')}đ`;
  } else {
    discountText = `Giảm ${Number(value).toLocaleString('vi-VN')}đ`;
  }

  const minOrderText = minOrder > 0
    ? ` - Đơn tối thiểu ${Number(minOrder).toLocaleString('vi-VN')}đ`
    : '';

  const expiryDate = coupon.expiryDate?.toDate?.();
  const expiryText = expiryDate
    ? ` - HSD: ${expiryDate.toLocaleDateString('vi-VN')}`
    : '';

  const usersSnap = await db.collection("Users").get();
  await Promise.allSettled(
    usersSnap.docs.map((doc) =>
      sendNotification({
        userId: doc.id,
        type: "promo",
        subtype: "coupon",
        title: `🎟️ Mã giảm giá mới: ${code}`,
        body: discountText + minOrderText + expiryText,
        data: { couponId, code },
      })
    )
  );
});
 
// ════════════════════════════════════════════════════════════
// 8. NOTIFICATION: Banner mới
// ════════════════════════════════════════════════════════════
 
exports.onNewBanner = onDocumentCreated("Banners/{bannerId}", async (event) => {
  const banner = event.data.data();
  const { bannerId } = event.params;
  if (!banner.isActive) return;
 
  const usersSnap = await db.collection("Users").get();
  await Promise.allSettled(
    usersSnap.docs.map((doc) =>
      sendNotification({
        userId: doc.id,
        type: "promo",
        subtype: "banner",
        title: "🔥 " + (banner.title || "Ưu đãi mới từ Shop"),
        body: banner.description || "Khám phá ngay các sản phẩm đang giảm giá",
        image: banner.imageUrl || null,
        data: { bannerId },
      })
    )
  );
});
 
// ════════════════════════════════════════════════════════════
// 9. NOTIFICATION: Sản phẩm đã xem giảm giá
// ════════════════════════════════════════════════════════════
 
exports.onProductPriceChange = onDocumentUpdated(
  "Products/{productId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    const { productId } = event.params;
 
    const oldPrice = before.salePrice || before.price;
    const newPrice = after.salePrice || after.price;
 
    if (!newPrice || newPrice >= oldPrice) return;
 
    const discount = Math.round(((oldPrice - newPrice) / oldPrice) * 100);
    if (discount < 10) return;
 
    const searchSnap = await db
      .collectionGroup("SearchHistory")
      .where("viewedProducts", "array-contains", productId)
      .get();
 
    const notifiedUsers = new Set();
    const batch = [];
 
    for (const doc of searchSnap.docs) {
      const userId = doc.ref.parent.parent.id;
      if (notifiedUsers.has(userId)) continue;
      notifiedUsers.add(userId);
 
      batch.push(
        sendNotification({
          userId,
          type: "personal",
          subtype: "price_drop",
          title: `💰 Sản phẩm bạn xem giảm ${discount}%`,
          body: `"${after.title || after.name}" đang giảm còn ${newPrice.toLocaleString("vi-VN")}đ`,
          image: after.thumbnail || after.images?.[0] || null,
          data: { productId },
        })
      );
    }
 
    await Promise.allSettled(batch);
  }
);
 
// ════════════════════════════════════════════════════════════
// 10. NOTIFICATION: Review được duyệt
// ════════════════════════════════════════════════════════════
 
exports.onReviewApproved = onDocumentUpdated(
  "Reviews/{reviewId}",
  async (event) => {
    const before = event.data.before.data();
    const after = event.data.after.data();
    const { reviewId } = event.params;
 
    if (before.status === "approved" || after.status !== "approved") return;
 
    await sendNotification({
      userId: after.userId,
      type: "review",
      subtype: "approved",
      title: "👍 Đánh giá của bạn đã được duyệt",
      body: "Cảm ơn bạn đã chia sẻ trải nghiệm. Đánh giá đã được hiển thị!",
      data: { reviewId, productId: after.productId },
    });
  }
);
 
// ════════════════════════════════════════════════════════════
// 11. NOTIFICATION: Tin nhắn chat mới
// ════════════════════════════════════════════════════════════
 
exports.onNewChatMessage = onDocumentCreated(
  "Chats/{chatId}/Messages/{messageId}",
  async (event) => {
    const message = event.data.data();
    const { chatId } = event.params;
 
    const chatDoc = await db.collection("Chats").doc(chatId).get();
    if (!chatDoc.exists) return;
 
    const chat = chatDoc.data();
    const senderId = message.senderId;
    const participants = chat.participants || [];
    const recipientId = participants.find((id) => id !== senderId);
    if (!recipientId) return;
 
    const senderDoc = await db.collection("Users").doc(senderId).get();
    const senderData = senderDoc.data() || {};
 
    await sendNotification({
      userId: recipientId,
      type: "chat",
      subtype: "message",
      title: senderData.name || "Shop",
      body: message.text || "Đã gửi một tệp đính kèm",
      image: senderData.avatar || null,
      data: { chatId, senderId },
    });
  }
);
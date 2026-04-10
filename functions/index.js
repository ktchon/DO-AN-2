const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");

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
      time: new Date(now - 10 * 60 * 60 * 1000),      // cũ nhất
    },
    ];

    const lastStatus = "delivering";

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
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

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
});
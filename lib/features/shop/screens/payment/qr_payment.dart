import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shop_app/common/widgets/success_screen/success_screen.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/constants/colors.dart';

class QRPaymentScreen extends StatefulWidget {
  final double amount;
  const QRPaymentScreen({super.key, required this.amount});
  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> {
  late String paymentNote;
  StreamSubscription? orderListener;

  @override
  void initState() {
    super.initState();

    paymentNote = "ORDER${DateTime.now().millisecondsSinceEpoch}";

    /// tạo order pending
    OrderController.instance.createPendingOrder(widget.amount, paymentNote);

    /// bắt đầu lắng nghe trạng thái thanh toán
    listenPaymentStatus();
  }

  void listenPaymentStatus() {
    final userId = AuthenticationRepository.instance.authUser!.uid;

    orderListener = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Orders")
        .doc(paymentNote)
        .snapshots()
        .listen((doc) {
          if (!doc.exists) return;

          final data = doc.data();

          if (data?['status'] == "paid") {
            orderListener?.cancel();

            Get.off(
              () => SuccessScreen(
                width: 150,
                height: 150,
                title: "Thanh toán thành công",
                subTitle: "Đơn hàng của bạn đã được xác nhận",
                animationJson: "assets/logo/Success.json",
                onPressed: () => Get.offAll(() => NavigationMenu()),
                check: true,
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    orderListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bankId = "MB";
    const accountNo = "3653134814551";
    const template = "compact2";
    const accountName = "KHUONG THIEN CHON";

    final qrUrl =
        "https://img.vietqr.io/image/$bankId-$accountNo-$template.png"
        "?amount=${widget.amount}&addInfo=$paymentNote&accountName=$accountName";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Thanh Toán QR',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Image.network(qrUrl, height: 500, width: 500),

            const SizedBox(height: 20),

            const Text("Nội dung chuyển khoản:"),

            SelectableText(paymentNote, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  // Hủy lắng nghe status
                  orderListener?.cancel();

                  // Gọi hàm cancelPendingOrder từ OrderController
                  await OrderController.instance.cancelPendingOrder(paymentNote);

                  // Quay lại màn hình trước
                  Get.back();
                },
                child: const Text("Huỷ thanh toán"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

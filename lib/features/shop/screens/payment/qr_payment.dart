import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:shop_app/common/widgets/success_screen/success_screen.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/features/authentication/screens/login/login.dart';
import 'package:shop_app/features/shop/controllers/order_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
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
  Timer? countdownTimer;
  Duration remainingTime = const Duration(minutes: 1);
  bool isExpired = false;

  @override
  void initState() {
    super.initState();

    paymentNote = "ORDER${DateTime.now().millisecondsSinceEpoch}";

    /// tạo order pending
    OrderController.instance.createPendingOrder(widget.amount, paymentNote);

    // Bắt đầu đếm ngược 10 phút
    startCountdown();

    /// bắt đầu lắng nghe trạng thái thanh toán
    listenPaymentStatus();
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds <= 0) {
          timer.cancel();
          isExpired = true;
          handleExpiration();
        } else {
          remainingTime = remainingTime - const Duration(seconds: 1);
        }
      });
    });
  }

  void handleExpiration() async {
    // Huỷ đơn hàng nếu hết hạn
    await OrderController.instance.cancelPendingOrder(paymentNote);

    // Thông báo cho người dùng
    Get.snackbar(
      "Hết thời gian thanh toán",
      "Đơn hàng đã được huỷ vì bạn chưa thanh toán trong 10 phút.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );

    // Quay lại màn hình trước hoặc giỏ hàng
    Get.back();
  }

  void listenPaymentStatus() {
    final authUser = AuthenticationRepository.instance.authUser;
    if (authUser == null) {
      print("Auth user null, không lắng nghe status");
      return;
    }
    final userId = authUser.uid;

    orderListener = FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .collection("Orders")
        .doc(paymentNote)
        .snapshots()
        .listen((doc) {
          if (!doc.exists || doc.data() == null) return;

          final data = doc.data()!;

          if (data['status'] == "paid") {
            orderListener?.cancel();
            //Xóa toàn bộ giỏ hàng
            final cartController = CartController.instance;
            cartController.clearCart();

            // Check lại authUser trước khi navigate
            if (AuthenticationRepository.instance.authUser == null) {
              Get.offAll(() => LoginScreen()); // hoặc màn hình login
              return;
            }

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
    countdownTimer?.cancel();
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
            if (!isExpired) Image.network(qrUrl, height: 500, width: 500),

            if (!isExpired) const SizedBox(height: 5),

            if (!isExpired) const Text("Nội dung chuyển khoản:"),

            if (!isExpired)
              SelectableText(paymentNote, style: const TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            // Đếm ngược
            if (!isExpired)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Thời gian còn lại: ${remainingTime.inMinutes}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),

            if (isExpired)
              Center(
                child: const Text(
                  "Đơn hàng đã hết hạn!",
                  style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: const Text(
                  "Vui lòng tạo đơn hàng mới để mua hàng.",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 20),
            if (!isExpired)
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
                  child: const Text("Huỷ thanh toán", style: TextStyle(color: Colors.red)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

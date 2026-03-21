import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app/data/coupon/coupon_repository.dart';
import 'package:shop_app/features/shop/models/coupon/coupon_model.dart';
import 'package:shop_app/utils/helpers/discount_calculator.dart';

class CouponController extends GetxController {
  static CouponController get instance => Get.find();
  final couponService = CouponService();

  Rx<CouponModel?> appliedCoupon = Rx<CouponModel?>(null);
  RxDouble discount = 0.0.obs;

  Future<void> applyCoupon(String code, double subtotal) async {
    final coupon = await couponService.getCoupon(code);

    if (coupon == null) {
      Get.snackbar("Lỗi", "Mã không tồn tại");
      return;
    }

    final discountValue = DiscountCalculator.calculateDiscount(subtotal: subtotal, coupon: coupon);

    if (discountValue == 0) {
      Get.snackbar("Không hợp lệ", "Mã không áp dụng được");
      return;
    }

    appliedCoupon.value = coupon;
    discount.value = discountValue;

    Get.snackbar("Thành công", "Áp dụng mã thành công");
  }
}

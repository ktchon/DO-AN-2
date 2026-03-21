import 'package:shop_app/features/shop/models/coupon/coupon_model.dart';

class DiscountCalculator {
  static double calculateDiscount({required double subtotal, required CouponModel coupon}) {
    if (!coupon.isActive) return 0;

    if (subtotal < coupon.minOrder) return 0;

    if (DateTime.now().isAfter(coupon.expiryDate)) return 0;

    double discount = 0;

    if (coupon.type == 'percentage') {
      discount = subtotal * (coupon.value / 100);

      if (coupon.maxDiscount != null) {
        discount = discount > coupon.maxDiscount! ? coupon.maxDiscount! : discount;
      }
    } else {
      discount = coupon.value;
    }

    return discount;
  }
}

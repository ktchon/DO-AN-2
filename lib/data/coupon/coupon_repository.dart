import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/models/coupon/coupon_model.dart';
import 'package:shop_app/utils/helpers/discount_calculator.dart';

class CouponService extends GetxController {
  static CouponService get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<CouponModel?> getCoupon(String code) async {
    final snapshot = await _db.collection('Coupons').where('code', isEqualTo: code).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return CouponModel.fromSnapshot(snapshot.docs.first);
  }

  Future<Map<String, dynamic>?> autoApplyBestCoupon(double subtotal) async {
    final snapshot = await _db.collection('Coupons').where('isActive', isEqualTo: true).get();

    double bestDiscount = 0;
    CouponModel? bestCoupon;

    for (var doc in snapshot.docs) {
      final coupon = CouponModel.fromSnapshot(doc);

      final discount = DiscountCalculator.calculateDiscount(subtotal: subtotal, coupon: coupon);

      if (discount > bestDiscount) {
        bestDiscount = discount;
        bestCoupon = coupon;
      }
    }

    if (bestCoupon != null) {
      return {'coupon': bestCoupon, 'discount': bestDiscount};
    }

    return null;
  }
}

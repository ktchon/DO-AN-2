import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/features/shop/models/coupon/coupon_model.dart';
import 'package:shop_app/utils/popups/loaders.dart';

Future<void> insertSampleCoupons() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  final List<CouponModel> coupons = [
    CouponModel(
      id: 'coupon1',
      code: 'SALE10',
      type: 'percentage',
      value: 10,
      minOrder: 200000,
      maxDiscount: 50000,
      expiryDate: DateTime.now().add(Duration(days: 30)),
      usageLimit: 100,
      usedCount: 0,
      isActive: true,
    ),
    CouponModel(
      id: 'coupon2',
      code: 'SALE50K',
      type: 'fixed',
      value: 50000,
      minOrder: 300000,
      maxDiscount: null,
      expiryDate: DateTime.now().add(Duration(days: 15)),
      usageLimit: 50,
      usedCount: 0,
      isActive: true,
    ),
    CouponModel(
      id: 'coupon3',
      code: 'FREESHIP',
      type: 'fixed',
      value: 30000,
      minOrder: 100000,
      maxDiscount: null,
      expiryDate: DateTime.now().add(Duration(days: 10)),
      usageLimit: 200,
      usedCount: 0,
      isActive: true,
    ),
  ];

  try {
    for (var coupon in coupons) {
      final docRef = firestore.collection('Coupons').doc(coupon.id);

      batch.set(docRef, coupon.toJson());
    }

    await batch.commit();

    CLoaders.successSnackBar(
      title: 'Thành công!',
      message: 'Đã thêm ${coupons.length} mã giảm giá',
    );
  } catch (e) {
    CLoaders.errorSnackBar(
      title: 'Lỗi!',
      message: 'Không thể thêm coupon: $e',
    );
  }
}
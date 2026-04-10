import 'package:get/get.dart';
import 'package:shop_app/data/coupon/coupon_repository.dart';
import 'package:shop_app/features/personalization/controllers/address_controller.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/shop/controllers/checkout_controller.dart';
import 'package:shop_app/features/shop/controllers/coupon/coupon_controller.dart';
import 'package:shop_app/features/shop/controllers/notification/notification_controller.dart';
import 'package:shop_app/features/shop/controllers/order_tracking_controller.dart';
import 'package:shop_app/features/shop/controllers/products/cart_conntroller.dart';
import 'package:shop_app/features/shop/controllers/products/variation_controller.dart';
import 'package:shop_app/features/shop/controllers/reviews/review_controller.dart';

import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// Core
    Get.put(NetworkManager());
    Get.put(VariationController());
    Get.put(CouponController());
    Get.put(CartController());
    Get.put(AddressController());
    Get.put(CouponService());
    Get.put(CheckoutController());
    Get.put(UserController());
    Get.put(ReviewController());
    Get.put(OrderTrackingController());
    Get.put(NotificationController(), permanent: true);
  }
}

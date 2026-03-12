import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/products/variation_controller.dart';

import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    /// -- Core
    Get.put(NetworkManager());
    Get.put(VariationController());
  }
}

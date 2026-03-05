import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/controllers/products/image_controller.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/models/product_variation_model.dart';

class VariationController extends GetxController {
  static VariationController get instance => Get.find();

  /// Biến
  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation = ProductVariationModel.empty().obs;

  /// -- Khi chọn Thuộc tính và Biến thể
  void onAttributeSelected(ProductModel product, attributeName, attributeValue) {
    // Khi thuộc tính được chọn, chúng ta sẽ thêm thuộc tính đó vào selectedAttributes
    final selectedAttributes = Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttributes[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    final selectedVariation = product.productVariations!.firstWhere(
      (variation) => _isSameAttributeValues(variation.attributeValues, selectedAttributes),
      orElse: () => ProductVariationModel.empty(),
    );

    // Hiển thị hình ảnh của biến thể đã chọn làm ảnh chính
    if (selectedVariation.image.isNotEmpty) {
      ImagesController.instance.selectedProductImage.value = selectedVariation.image;
    }

    // Gán biến thể đã chọn
    this.selectedVariation.value = selectedVariation;
  }

  /// -- Kiểm tra xem các thuộc tính đã chọn có khớp với thuộc tính của bất kỳ biến thể nào không
  bool _isSameAttributeValues(
    Map<String, dynamic> variationAttributes,
    Map<String, dynamic> selectedAttributes,
  ) {
    // Nếu selectedAttributes có 3 thuộc tính mà biến thể hiện tại chỉ có 2 thì trả về false
    if (variationAttributes.length != selectedAttributes.length) return false;

    // Nếu bất kỳ thuộc tính nào khác nhau thì trả về false. VD: [Green, Large] x [Green, Small]
    for (final key in variationAttributes.keys) {
      // Attributes[key] = Giá trị có thể là [Green, Small, Cotton] v.v.
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }

    return true;
  }

  /// -- Lấy danh sách các giá trị thuộc tính còn khả dụng (còn hàng) trong các biến thể
  Set<String>? getAttributesAvailabilityInVariation(
    List<ProductVariationModel> variations,
    String attributeName,
  ) {
    // Truyền danh sách biến thể vào để kiểm tra giá trị thuộc tính nào còn khả dụng và stock > 0
    final availableVariationAttributeValues = variations
        .where(
          (variation) =>
              // Kiểm tra thuộc tính không rỗng / không hết hàng
              variation.attributeValues[attributeName] != null &&
              variation.attributeValues[attributeName]!.isNotEmpty &&
              variation.stock > 0,
        )
        // Lấy tất cả giá trị thuộc tính không rỗng của các biến thể
        .map((variation) => variation.attributeValues[attributeName]!)
        .toSet();

    return availableVariationAttributeValues;
  }

  /// Lấy giá của biến thể hiện tại (ưu tiên giá sale nếu có)
  num getVariationPrice() {
    final variation = selectedVariation.value;

    // Nếu có giá sale > 0 thì dùng salePrice, ngược lại dùng price
    return variation.salePrice > 0 ? variation.salePrice : variation.price;
  }

  /// -- Kiểm tra trạng thái tồn kho của biến thể sản phẩm
  void getProductVariationStockStatus() {
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'Còn hàng' : 'Hết hàng';
  }

  /// -- Đặt lại các thuộc tính đã chọn khi chuyển sang sản phẩm khác
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    variationStockStatus.value = '';
    selectedVariation.value = ProductVariationModel.empty();
  }
}

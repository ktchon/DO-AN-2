import 'package:shop_app/data/products/share_product_repository.dart';
import 'package:shop_app/features/shop/models/share_product_model.dart';

class ShareProductController {
  final ShareProductRepository _repository;

  ShareProductController(this._repository);

  Future<void> share(ShareProductModel product) async {
    /// Validate dữ liệu
    if (product.title.isEmpty || product.productUrl.isEmpty) {
      throw Exception("Dữ liệu sản phẩm không hợp lệ");
    }

    await _repository.shareProduct(product);
  }
}

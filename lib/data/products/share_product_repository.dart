import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/shop/models/share_product_model.dart';

class ShareProductRepository {
  Future<void> shareProduct(ShareProductModel product) async {
    final message = product.buildShareMessage();

    /// lấy thư mục tạm
    final tempDir = await getTemporaryDirectory();

    /// đường dẫn file ảnh
    final file = File('${tempDir.path}/product_${product.id}.jpg');

    /// nếu chưa có ảnh thì tải
    if (!file.existsSync()) {
      final response = await http.get(Uri.parse(product.imageUrl));
      await file.writeAsBytes(response.bodyBytes);
    }

    /// share ảnh + text
    await Share.shareXFiles([XFile(file.path)], text: message, subject: product.title);
  }
}

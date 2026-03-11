class ShareProductModel {
  final String id;
  final String title;
  final double price;
  final double salePrice;
  final String imageUrl;
  final String productUrl;

  const ShareProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.productUrl,
    required this.salePrice,
  });

  /// Tạo nội dung chia sẻ
  String buildShareMessage() {
    return '''
      $title
      Giá: $price - $salePrice VNĐ
      Xem sản phẩm:
      $productUrl
      ''';
  }
}

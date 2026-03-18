class CartItemModel {
  String productId; // ID của sản phẩm (thường là ID chính từ database)
  String title; // Tên sản phẩm
  double price; // Giá của sản phẩm (sau khi áp dụng biến thể nếu có)
  String? image; // Link ảnh sản phẩm (có thể null)
  int quantity; // Số lượng trong giỏ hàng
  String? variationId; // ID của biến thể (màu sắc, kích cỡ,...) - mặc định rỗng nếu không có
  String brandName; // Tên thương hiệu
  Map<String, String>?
  selectedVariation; // Các lựa chọn biến thể đã chọn (ví dụ: {'Màu': 'Đen', 'Size': 'M'})

  // Constructor chính (sử dụng named parameters)
  CartItemModel({
    required this.productId, // Bắt buộc
    required this.quantity, // Bắt buộc
    this.variationId = '', // Mặc định rỗng nếu không truyền
    this.image, // Có thể null
    this.price = 0.0, // Mặc định 0 nếu không truyền
    this.title = '', // Mặc định rỗng
    this.brandName = '', // Mặc định rỗng
    this.selectedVariation, // Có thể null
  });

  // Factory constructor tạo một CartItem rỗng (dùng để khởi tạo giỏ hàng ban đầu)
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0);

  /// Chuyển đối tượng CartItemModel thành Map<String, dynamic> để lưu vào JSON
  /// (thường dùng khi gửi dữ liệu lên server hoặc lưu vào local storage như SharedPreferences, Hive, ...)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'variationId': variationId,
      'brandName': brandName,
      'selectedVariation': selectedVariation, // Map sẽ tự động serialize thành JSON object
    };
  }

  /// Tạo đối tượng CartItemModel từ dữ liệu JSON (Map)
  /// (thường dùng khi nhận dữ liệu từ server hoặc đọc từ local storage)
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      variationId: json['variationId'] as String? ?? '',
      brandName: json['brandName'] as String? ?? '',
      selectedVariation: json['selectedVariation'] != null
          ? Map<String, String>.from(json['selectedVariation'] as Map)
          : null,
    );
  }
}

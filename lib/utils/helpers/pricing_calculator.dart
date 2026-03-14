class CPricingCalculator {
  /// Tổng tiền = Giá sản phẩm + VAT + Ship
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(productPrice, location);

    return productPrice + taxAmount + shippingCost;
  }

  /// Tính phí vận chuyển
  static double getShippingCost(double productPrice, String location) {
    /// Miễn phí vận chuyển nếu đơn > 500k
    if (productPrice >= 500000) {
      return 0;
    }

    /// Nội thành
    if (location.toLowerCase().contains("Hà Nội") ||
        location.toLowerCase().contains("Hồ Chí Minh") ||
        location.toLowerCase().contains("Hải Phòng") ||
        location.toLowerCase().contains("Đà Nẵng") ||
        location.toLowerCase().contains("Cần Thơ")) {
      return 20000;
    }

    /// Các tỉnh khác
    return 35000;
  }

  /// Thuế VAT Việt Nam
  static double getTaxRateForLocation(String location) {
    return 0.10; // 10% VAT
  }

  /// Tính tiền thuế
  static double calculateTax(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    return productPrice * taxRate;
  }

  /// Lấy phí ship
  static double calculateShippingCost(double productPrice, String location) {
    return getShippingCost(productPrice, location);
  }
}

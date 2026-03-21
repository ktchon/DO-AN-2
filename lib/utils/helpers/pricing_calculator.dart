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
    if (productPrice >= 500000) return 0;

    final loc = location.toLowerCase();

    const bigCities = ["hà nội", "hồ chí minh", "hải phòng", "đà nẵng", "cần thơ"];

    if (bigCities.any((city) => loc.contains(city))) {
      return 20000;
    }

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

  // Tính tổng giảm giá
  static double calculateTotalWithDiscount({
    required double subTotal,
    required double discount,
    required String location,
  }) {
    final shipping = calculateShippingCost(subTotal, location);
    final tax = calculateTax(subTotal, 'VN');

    return subTotal + shipping + tax - discount;
  }
}

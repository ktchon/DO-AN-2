// lib/features/shop/services/product_scoring_service.dart
import 'dart:math';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'user_behavior_service.dart';

class ProductScoringService {
  static const _scoreSearchedMatch      = 40; // keyword khớp tên/mô tả sản phẩm
  static const _scoreRelatedCategory    = 30; // cùng danh mục đã mua
  static const _scoreNewProduct         = 20; // sản phẩm mới < 30 ngày
  static const _scoreDefault            = 5;

  static List<ProductModel> rankAndShuffle(
    List<ProductModel> products,
    UserBehavior behavior,
  ) {
    final rng = Random();

    final scored = products.map((p) {
      final score = _score(p, behavior);
      // Thêm nhiễu nhỏ để sản phẩm cùng điểm không xếp cứng
      final noise = rng.nextDouble() * 6;
      return _ScoredProduct(product: p, finalScore: score + noise);
    }).toList()
      ..sort((a, b) => b.finalScore.compareTo(a.finalScore));

    return scored.map((s) => s.product).toList();
  }

  static int _score(ProductModel product, UserBehavior behavior) {
    int score = _scoreDefault;
    final title = product.title.toLowerCase();

    // +40: keyword đã tìm khớp tên sản phẩm (substring match)
    final matched = behavior.searchedKeywords.any(
      (kw) => kw.isNotEmpty && title.contains(kw),
    );
    if (matched) score += _scoreSearchedMatch;

    // +30: cùng danh mục với sản phẩm đã mua
    if (behavior.purchasedCategoryIds.contains(product.categoryId)) {
      score += _scoreRelatedCategory;
    }

    // +20: sản phẩm mới trong 30 ngày
    if (_isNew(product)) score += _scoreNewProduct;

    return score;
  }

  static bool _isNew(ProductModel product) {
    if (product.date == null) return false;
    return product.date!.isAfter(
      DateTime.now().subtract(const Duration(days: 30)),
    );
  }
}

class _ScoredProduct {
  final ProductModel product;
  final double finalScore;
  _ScoredProduct({required this.product, required this.finalScore});
}
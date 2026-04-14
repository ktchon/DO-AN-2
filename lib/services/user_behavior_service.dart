// lib/features/shop/services/user_behavior_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/features/shop/models/product_model.dart';
import 'package:shop_app/features/shop/models/search/search_history_model.dart';

class UserBehavior {
  final List<String> searchedKeywords;     // keywords đã tìm
  final List<String> purchasedProductIds;  // productId đã mua
  final List<String> purchasedCategoryIds; // categoryId đã mua

  UserBehavior({
    required this.searchedKeywords,
    required this.purchasedProductIds,
    required this.purchasedCategoryIds,
  });

  static UserBehavior empty() => UserBehavior(
    searchedKeywords: [],
    purchasedProductIds: [],
    purchasedCategoryIds: [],
  );
}

class UserBehaviorService {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<UserBehavior> getUserBehavior() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return UserBehavior.empty();

    try {
      // Lấy SearchHistory từ Firestore
      final searchSnap = await _db
          .collection('Users')
          .doc(uid)
          .collection('SearchHistory')
          .orderBy('timestamp', descending: true)
          .limit(30)
          .get();

      final keywords = searchSnap.docs
          .map((d) => SearchHistoryModel.fromSnapshot(d).keyword.toLowerCase().trim())
          .toSet() // bỏ trùng
          .toList();

      // Lấy Orders để lấy danh sách sản phẩm đã mua
      final ordersSnap = await _db
          .collection('Users')
          .doc(uid)
          .collection('Orders')
          .orderBy('CreatedAt', descending: true)
          .limit(20)
          .get();

      final purchasedProductIds  = <String>{};
      final purchasedCategoryIds = <String>{};

      for (final doc in ordersSnap.docs) {
        final data  = doc.data();
        final items = data['Items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final pid = item['ProductId']?.toString()  ?? '';
          final cid = item['CategoryId']?.toString() ?? '';
          if (pid.isNotEmpty) purchasedProductIds.add(pid);
          if (cid.isNotEmpty) purchasedCategoryIds.add(cid);
        }
      }

      return UserBehavior(
        searchedKeywords:     keywords,
        purchasedProductIds:  purchasedProductIds.toList(),
        purchasedCategoryIds: purchasedCategoryIds.toList(),
      );
    } catch (_) {
      return UserBehavior.empty();
    }
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shop_app/utils/helpers/helper_functions.dart';
import '../../../features/shop/models/product_model.dart';

class SearchRepository extends GetxController {
  static SearchRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> getAutocompleteSuggestions(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return [];

    final String searchKey = THelperFunctions.removeDiacritics(cleanQuery.toLowerCase());

    print('🔍 Query key: "$searchKey"');

    try {
      final snapshot = await _db
          .collection('Products')
          .orderBy('SearchName') 
          .where('SearchName', isGreaterThanOrEqualTo: searchKey)
          .where('SearchName', isLessThanOrEqualTo: '$searchKey\uf8ff')
          .limit(10)
          .get();

      final results = snapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      print('✅ Found ${results.length} results for "$searchKey"');

      return results;
    } catch (e) {
      print('❌ Firestore error: $e');
      return [];
    }
  }

  // 2. Lưu lịch sử tìm kiếm vào Firebase của User
  Future<void> saveSearchHistory(String userId, String keyword) async {
    try {
      final historyRef = _db.collection('Users').doc(userId).collection('SearchHistory');

      // Kiểm tra nếu từ khóa đã tồn tại thì cập nhật timestamp, chưa thì thêm mới
      final existing = await historyRef.where('keyword', isEqualTo: keyword).get();

      if (existing.docs.isNotEmpty) {
        await existing.docs.first.reference.update({'timestamp': FieldValue.serverTimestamp()});
      } else {
        await historyRef.add({'keyword': keyword, 'timestamp': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      print("Không thể lưu lịch sử: $e");
    }
  }

  // 3. Lấy lịch sử tìm kiếm gần đây
  Future<List<String>> getRecentSearches(String userId) async {
    final snapshot = await _db
        .collection('Users')
        .doc(userId)
        .collection('SearchHistory')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => doc['keyword'] as String).toList();
  }

  // 4. Lấy Trending (Dựa trên sản phẩm bán chạy nhất - field 'Sold' trong data của bạn)
  Future<List<String>> getTrendingSearches() async {
    final snapshot = await _db
        .collection('Products')
        .orderBy('Sold', descending: true)
        .limit(6)
        .get();
    return snapshot.docs.map((doc) => doc['SearchName'] as String).toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  /// CREATE REVIEW
  Future<void> createReview(ReviewModel review) async {
    final data = review.toJson();

    data['createdAt'] = FieldValue.serverTimestamp();

    await _db.collection('Reviews').add(data);
  }

  /// GET REVIEWS BY PRODUCT
  Future<List<ReviewModel>> getReviews(String productId) async {
    final snapshot = await _db
        .collection('Reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .get();
    print("Docs length: ${snapshot.docs.length}");

    return snapshot.docs.map((e) => ReviewModel.fromSnapshot(e)).toList();
  }

  /// LIKE REVIEW
  Future<void> likeReview(String reviewId, String userId) async {
    final ref = _db.collection('Reviews').doc(reviewId);

    await ref.collection('likedBy').doc(userId).set({}); // đánh dấu user đã like
    await ref.update({'likes': FieldValue.increment(1)});
  }

  /// REPORT
  Future<void> reportReview({
    required String reviewId,
    required String userId,
    required String reason,
  }) async {
    await _db.collection('Reviews').doc(reviewId).collection('Reports').add({
      'userId': userId,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // UNLIKE
  Future<void> unlikeReview(String reviewId, String userId) async {
    final ref = _db.collection('Reviews').doc(reviewId);

    await ref.collection('likedBy').doc(userId).delete(); // xóa user đã like
    await ref.update({'likes': FieldValue.increment(-1)});
  }

  /// CHECK USER ĐÃ LIKE CHƯA
  Future<bool> hasUserLiked(String reviewId, String userId) async {
    final doc = await _db
        .collection('Reviews')
        .doc(reviewId)
        .collection('likedBy')
        .doc(userId)
        .get();

    return doc.exists;
  }
}

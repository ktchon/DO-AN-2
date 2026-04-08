import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';

class ReviewRepository extends GetxController {
  static ReviewRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// CREATE REVIEW
  Future<void> createReview(ReviewModel review) async {
    final docId = "${review.productId}_${review.userId}";
    final data = review.toJson();

    data['createdAt'] = FieldValue.serverTimestamp();

    await _db.collection('Reviews').doc(docId).set(data);
  }

  Future<bool> hasUserReviewed(String productId, String userId) async {
    final snapshot = await _db
        .collection('Reviews')
        .where('productId', isEqualTo: productId)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
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
  Future<void> reportReview(String reviewId, String reason) async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;
    // Chống spam báo cáo
    final existing = await _db
        .collection("Reports")
        .where("reviewId", isEqualTo: reviewId)
        .where("userId", isEqualTo: userId)
        .get();

    if (existing.docs.isNotEmpty) {
      throw "Bạn đã báo cáo rồi";
    }

    await _db.collection("Reports").add({
      "reviewId": reviewId,
      "userId": userId,
      "reason": reason,
      "createdAt": FieldValue.serverTimestamp(),
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

  // updateReview
  Future<void> updateReview(
    String reviewId, {
    required double rating,
    required String comment,
    required bool isAnonymous,
    required List<String> images,
  }) async {
    await _db.collection("Reviews").doc(reviewId).update({
      "rating": rating,
      "comment": comment,
      "isAnonymous": isAnonymous,
      "images": images,
      "updatedAt": DateTime.now(),
    });
  }

  // deleteReview
  Future<void> deleteReview(String reviewId) async {
    await _db.collection("Reviews").doc(reviewId).delete();
  }

  // Lấy bình luận của user
  Future<List<ReviewModel>> getReviewsByUser(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Reviews')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => ReviewModel.fromSnapshot(doc)).toList();
  }
}

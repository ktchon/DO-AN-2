import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/common/widgets/success_screen/success_screen.dart';
import 'package:shop_app/data/repositories/authentication/authentication_repository.dart';
import 'package:shop_app/data/repositories/user/user_repository.dart';
import 'package:shop_app/data/reviews/review_repository.dart';
import 'package:shop_app/features/personalization/controllers/user/user_controller.dart';
import 'package:shop_app/features/shop/models/cart_item_model.dart';
import 'package:shop_app/features/shop/models/reviews/reviews_model.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/helpers/full_screen_gallery.dart';
import 'package:shop_app/utils/helpers/full_screen_gallery_files.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final repo = ReviewRepository();

  /// USER
  final userController = UserController.instance;
  final authRepo = AuthenticationRepository.instance;

  /// STATE
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxnString editingReviewId = RxnString();
  ReviewModel? editingReview;

  /// FORM STATE
  RxDouble rating = 0.0.obs;
  RxString comment = ''.obs;
  RxBool isAnonymous = false.obs;

  /// IMAGE
  RxList<XFile> selectedImages = <XFile>[].obs;
  final ImagePicker _picker = ImagePicker();
  RxList<String> existingImages = <String>[].obs;

  /// Reviews
  RxMap<String, bool> reviewedMap = <String, bool>{}.obs;

  /// ================= FETCH REVIEWS =================
  Future<void> fetchReviews(String productId) async {
    try {
      isLoading.value = true;

      final userId = authRepo.authUser?.uid;

      final data = await repo.getReviews(productId);

      /// 👉 check like từng review
      for (var review in data) {
        if (userId != null) {
          review.isLiked = await repo.hasUserLiked(review.id, userId);
        }
      }

      reviews.assignAll(data);
    } catch (e) {
      print("Error fetch reviews: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Lấy 2 bình luận mới nhất
  Future<List<ReviewModel>> fetchLatestReviews(String productId, {int limit = 2}) async {
    final data = await repo.getReviews(productId);

    data.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return data.take(limit).toList();
  }

  /// ================= PICK IMAGE =================
  Future<void> pickImages() async {
    /// Giới hạn trước khi chọn
    if (selectedImages.length >= 5) {
      Get.snackbar("Tối đa", "Chỉ được chọn tối đa 5 ảnh");
      return;
    }

    final images = await _picker.pickMultiImage(imageQuality: 70, maxWidth: 512, maxHeight: 512);

    if (images != null && images.isNotEmpty) {
      /// Giới hạn sau khi chọn (trường hợp user chọn nhiều cùng lúc)
      final remainingSlots = 5 - selectedImages.length;

      selectedImages.addAll(images.take(remainingSlots));

      if (images.length > remainingSlots) {
        Get.snackbar("Thông báo", "Chỉ lấy ${remainingSlots} ảnh");
      }
    }
  }

  /// ================= REMOVE IMAGE =================
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  /// ================= SUBMIT REVIEW =================
  Future<void> submitReview({required CartItemModel item}) async {
    if (isSubmitting.value) return;
    try {
      isSubmitting.value = true;

      /// Lấy user hiện tại
      final user = userController.user.value;
      final firebaseUser = authRepo.authUser;

      if (firebaseUser == null) {
        throw "User chưa đăng nhập";
      }
      final userId = firebaseUser.uid;

      /// ================= EDIT MODE =================
      if (editingReviewId.value != null) {
        /// ===== 1. Upload ảnh mới =====
        List<String> newImageUrls = [];

        for (int i = 0; i < selectedImages.length; i++) {
          final img = selectedImages[i];

          final url = await UserRepository.instance.uploadImage('Reviews/${item.productId}/', img);

          newImageUrls.add(url);
        }

        /// ===== 2. Gộp ảnh cũ + ảnh mới =====
        List<String> allImages = [];

        // thêm ảnh cũ còn lại
        for (int i = 0; i < existingImages.length; i++) {
          allImages.add(existingImages[i]);
        }

        // thêm ảnh mới
        for (int i = 0; i < newImageUrls.length; i++) {
          allImages.add(newImageUrls[i]);
        }

        /// ===== 3. Update review =====
        await repo.updateReview(
          editingReviewId.value!,
          rating: rating.value,
          comment: comment.value,
          isAnonymous: isAnonymous.value,
          images: allImages, // 👈 QUAN TRỌNG
        );

        /// ===== 4. Reset state =====
        editingReviewId.value = null;
        editingReview = null;

        /// reload lại list
        await fetchReviews(item.productId);

        /// reset form
        resetForm();

        Get.back();

        return;
      }

      /// CHẶN SPAM REVIEW
      final alreadyReviewed = await repo.hasUserReviewed(item.productId, userId);

      if (alreadyReviewed) {
        Get.snackbar("Thông báo", "Bạn đã đánh giá sản phẩm này rồi");
        return;
      }

      /// Upload ảnh
      List<String> imageUrls = [];
      for (var img in selectedImages) {
        final url = await UserRepository.instance.uploadImage('Reviews/${item.productId}/', img);
        imageUrls.add(url);
      }

      /// Tạo review
      final review = ReviewModel(
        id: '',
        productId: item.productId,
        userId: firebaseUser.uid,
        userName: isAnonymous.value ? "Ẩn danh" : user.fullName,
        userAvatar: isAnonymous.value ? "" : user.profilePicture,

        rating: rating.value,
        comment: comment.value,
        images: imageUrls,

        variation: item.selectedVariation,
        likes: 0,
        createdAt: DateTime.now(),
        isAnonymous: isAnonymous.value,
        isLiked: false,
      );

      await repo.createReview(review);
      reviewedMap[item.productId] = true;
      await fetchReviews(item.productId);

      /// RESET FORM
      rating.value = 0.0;
      comment.value = '';
      selectedImages.clear();
      isAnonymous.value = false;

      Get.off(
        () => SuccessScreen(
          title: "Thành công!",
          subTitle: "Đánh giá của bạn đã được gửi",
          check: false,
          animationJson: 'assets/logo/Success.json',
          onPressed: () {
            Get.offAll(() => NavigationMenu());
          },
        ),
      );
    } catch (e) {
      print("Gửi đánh giá thất bại!: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> like(String reviewId) async {
    try {
      final userId = authRepo.authUser?.uid;
      if (userId == null) return;

      final index = reviews.indexWhere((r) => r.id == reviewId);
      if (index == -1) return;

      final review = reviews[index];

      /// 👉 check từ Firebase (chuẩn nhất)
      final isLikedFromServer = await repo.hasUserLiked(reviewId, userId);

      if (isLikedFromServer) {
        /// UNLIKE
        review.likes -= 1;
        review.isLiked = false;

        await repo.unlikeReview(reviewId, userId);
      } else {
        /// LIKE
        review.likes += 1;
        review.isLiked = true;

        await repo.likeReview(reviewId, userId);
      }

      reviews.refresh();
    } catch (e) {
      print("Like error: $e");
    }
  }

  /// check user đã review chưa theo productId
  Future<void> checkUserReviewed(String productId) async {
    if (reviewedMap.containsKey(productId)) return;
    final userId = authRepo.authUser?.uid;
    if (userId == null) return;

    final result = await repo.hasUserReviewed(productId, userId);
    reviewedMap[productId] = result;
  }

  // Hàm đánh giá trung bình sao
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  int get totalReviews => reviews.length;

  Map<int, int> get ratingCount {
    final Map<int, int> counts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var r in reviews) {
      final star = r.rating.round();
      if (counts.containsKey(star)) {
        counts[star] = counts[star]! + 1;
      }
    }

    return counts;
  }

  Map<int, double> get ratingPercent {
    final total = reviews.length;
    if (total == 0) return {};

    final counts = ratingCount;

    return counts.map((key, value) {
      return MapEntry(key, value / total);
    });
  }

  // CHECK OWNER
  bool isMyReview(String userId) {
    return authRepo.authUser?.uid == userId;
  }

  // SET EDIT
  void setEditingReview(ReviewModel review) {
    editingReviewId.value = review.id;
    editingReview = review;

    rating.value = review.rating;
    comment.value = review.comment;
    isAnonymous.value = review.isAnonymous;

    /// LOAD ẢNH REVIEW CŨ
    existingImages.assignAll(review.images);

    /// reset ảnh mới
    selectedImages.clear();
  }

  // DELETE REVIEW
  Future<void> deleteReview(String reviewId, String productId) async {
    try {
      await repo.deleteReview(reviewId);

      reviews.removeWhere((r) => r.id == reviewId);
      reviewedMap[productId] = false;

      Get.snackbar("Thành công", "Đã xoá đánh giá");
    } catch (e) {
      print(e);
    }
  }

  // reportReview
  Future<void> reportReview({required String reviewId, required String reason}) async {
    try {
      await repo.reportReview(reviewId, reason);

      Get.snackbar("Thành công", "Đã gửi báo cáo");
    } catch (e) {
      print(e);
    }
  }

  void resetForm() {
    rating.value = 0.0;
    comment.value = '';
    selectedImages.clear();
    isAnonymous.value = false;

    editingReviewId.value = null;
    editingReview = null;
  }

  // Xem full ảnh
  void openFullScreen(BuildContext context, List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenGallery(imageUrls: images, initialIndex: index),
      ),
    );
  }

  void openFullScreenFiles(BuildContext context, List<XFile> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenGalleryFiles(images: images, initialIndex: index),
      ),
    );
  }
}

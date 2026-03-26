import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class ReviewModel {
  String id;
  String productId;
  String userId;
  String userName;
  String userAvatar;

  double rating;
  String comment;
  List<String> images;

  Map<String, String>? variation;

  int likes;
  DateTime createdAt;

  bool isAnonymous;
  bool isLiked;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.images,
    this.variation,
    required this.likes,
    required this.createdAt,
    required this.isAnonymous,
    required this.isLiked,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'rating': rating,
    'comment': comment,
    'images': images,
    'variation': variation,
    'likes': likes,
    'createdAt': createdAt,
    'isAnonymous': isAnonymous,
  };

  factory ReviewModel.fromSnapshot(doc) {
    final data = doc.data();
    return ReviewModel(
      id: doc.id,
      productId: data['productId'],
      userId: data['userId'],
      userName: data['userName'],
      userAvatar: data['userAvatar'],
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      variation: Map<String, String>.from(data['variation'] ?? {}),
      likes: data['likes'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAnonymous: data['isAnonymous'] ?? false,
      isLiked: data['isLiked'] ?? false,
    );
  }
}

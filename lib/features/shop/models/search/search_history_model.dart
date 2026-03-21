import 'package:cloud_firestore/cloud_firestore.dart';

class SearchHistoryModel {
  String id;
  String keyword;
  DateTime timestamp;

  SearchHistoryModel({required this.id, required this.keyword, required this.timestamp});

  Map<String, dynamic> toJson() => {'keyword': keyword, 'timestamp': timestamp};

  factory SearchHistoryModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return SearchHistoryModel(
      id: document.id,
      keyword: data['keyword'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

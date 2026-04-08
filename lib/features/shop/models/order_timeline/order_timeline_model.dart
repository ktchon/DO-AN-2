import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTimeline {
  final String status;
  final String title;
  final DateTime time;

  OrderTimeline({required this.status, required this.title, required this.time});

  factory OrderTimeline.fromMap(Map<String, dynamic> map) {
    return OrderTimeline(status: map['status'], title: map['title'], time: map['time'].toDate());
  }
  Map<String, dynamic> toJson() {
    return {'status': status, 'title': title, 'time': Timestamp.fromDate(time)};
  }
}

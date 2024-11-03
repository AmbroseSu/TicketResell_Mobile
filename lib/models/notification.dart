import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String title;
  final String body;
  final int? ticketRequestId;  // Thêm trường ticketRequestId
  final Timestamp timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.body,
    this.ticketRequestId,  // Thêm vào constructor
    required this.timestamp,
    this.isRead = false,
  });

  // Phương thức để chuyển JSON sang đối tượng Dart
  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      title: json['title'],
      body: json['body'],
      ticketRequestId: json['ticketRequestId'] is int
    ? json['ticketRequestId']
        : int.tryParse(json['ticketRequestId']?.toString() ?? ''),  // Lấy giá trị từ JSON
      timestamp: json['timestamp'],
      isRead: json['isRead'] ?? false,
    );
  }

  NotificationModel copyWith({String? id}) {
    return NotificationModel(
      id: id ?? this.id, // Sử dụng id mới nếu có, ngược lại dùng id hiện tại
      senderId: senderId,
      receiverId: receiverId,
      title: title,
      body: body,
      ticketRequestId: ticketRequestId,
      timestamp: timestamp,
      isRead: isRead,
    );
  }

  // Phương thức để chuyển đổi đối tượng Dart thành JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'title': title,
      'body': body,
      'ticketRequestId': ticketRequestId,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}


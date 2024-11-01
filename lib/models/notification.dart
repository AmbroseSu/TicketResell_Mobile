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
      ticketRequestId: json['ticketRequestId'],  // Lấy giá trị từ JSON
      timestamp: json['timestamp'],
      isRead: json['isRead'] ?? false,
    );
  }

  // Phương thức để chuyển đổi đối tượng Dart thành JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'title': title,
      'body': body,
      'ticketRequestId': ticketRequestId,  // Thêm vào JSON
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm thông báo mới
  Future<void> addNotification(NotificationModel notification) async {
    await _firestore.collection('notifications').add(notification.toJson());
  }

  // Lấy danh sách thông báo cho người dùng
  Stream<List<NotificationModel>> getNotifications(String receiverId) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  // Đánh dấu thông báo là đã đọc
  Future<void> markNotificationAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
}

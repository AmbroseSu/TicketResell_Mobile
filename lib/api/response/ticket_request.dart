import 'package:intl/intl.dart';

class TicketRequest {
  final int id;
  final int price;
  final int quantity;
  final DateTime ticketRequestDate;
  final String address;
  final int status;
  final bool isDeleted;
  final String userFullname;
  final String userEmail;
  final int userId;
  final int ticketId;

  TicketRequest({
    required this.id,
    required this.price,
    required this.quantity,
    required this.ticketRequestDate,
    required this.address,
    required this.status,
    required this.isDeleted,
    required this.userFullname,
    required this.userEmail,
    required this.userId,
    required this.ticketId,
  });

  // Phương thức để chuyển JSON sang đối tượng Dart
  factory TicketRequest.fromJson(Map<String, dynamic> json) {
    return TicketRequest(
      id: json['id'],
      price: json['price'],
      quantity: json['quantity'],
      ticketRequestDate: DateTime.parse(json['ticketRequestDate']),
      address: json['address'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      userFullname: json['userFullname'],
      userEmail: json['userEmail'],
      userId: json['userId'],
      ticketId: json['ticketId'],
    );
  }

  // Phương thức định dạng lại ticketRequestDate
  String get formattedDate {
    return DateFormat('HH:mm dd-MM-yyyy').format(ticketRequestDate);
  }

  String get statusText {
    switch (status) {
      case 1:
        return 'Confirmed';
      case 0:
        return 'Pending';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}

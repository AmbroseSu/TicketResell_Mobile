import 'dart:convert';

class Order {
  final int id;
  final double price;
  final int quantity;
  final String address;
  final DateTime orderDate;
  final bool isDeleted;
  final int? orderStatusIds;
  final int ticketId;
  final int userId;

  Order({
    required this.id,
    required this.price,
    required this.quantity,
    required this.address,
    required this.orderDate,
    required this.isDeleted,
    this.orderStatusIds,
    required this.ticketId,
    required this.userId,
  });

  // Chuyển từ JSON sang đối tượng Order
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      address: json['address'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      isDeleted: json['isDeleted'] as bool,
      orderStatusIds: json['orderStatusIds'] as int?,
      ticketId: json['ticketId'] as int,
      userId: json['userId'] as int,
    );
  }

  // Chuyển từ đối tượng Order sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'address': address,
      'orderDate': orderDate.toIso8601String(),
      'isDeleted': isDeleted,
      'orderStatusIds': orderStatusIds,
      'ticketId': ticketId,
      'userId': userId,
    };
  }
}

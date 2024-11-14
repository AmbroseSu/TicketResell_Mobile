import 'dart:convert';


class PlatformFeeDto {
  final int id;
  final String name;
  final int quantity;
  final double price;
  final bool isDeleted;

  PlatformFeeDto({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.isDeleted,
  });

  factory PlatformFeeDto.fromJson(Map<String, dynamic> json) {
    return PlatformFeeDto(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      isDeleted: json['isDeleted'],
    );
  }
}

class Transaction {
  final int id;
  final double price;
  final int orderCode;
  final DateTime transactionDate;
  final String paymentMethod;
  final int promotion;
  final String status;
  final PlatformFeeDto? platformFee;

  Transaction({
    required this.id,
    required this.price,
    required this.orderCode,
    required this.transactionDate,
    required this.paymentMethod,
    required this.promotion,
    required this.status,
    this.platformFee,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      price: json['price'].toDouble(),
      orderCode: json['orderCode'],
      transactionDate: json['transactionDate'] is String
          ? DateTime.parse(json['transactionDate'])
          : json['transactionDate'],
      paymentMethod: json['paymentMethod'],
      promotion: json['promotion'],
      status: json['status'],
      platformFee: json['platformFeeDto'] != null
          ? PlatformFeeDto.fromJson(json['platformFeeDto'])
          : null,
    );
  }
}

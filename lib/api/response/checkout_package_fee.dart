class CheckoutPackageFee {
  final String bin;
  final String accountNumber;
  final int amount;
  final String description;
  final int orderCode;
  final String currency;
  final String paymentLinkId;
  final String status;
  final String? expiredAt;
  final String checkoutUrl;
  final String qrCode;

  CheckoutPackageFee({
    required this.bin,
    required this.accountNumber,
    required this.amount,
    required this.description,
    required this.orderCode,
    required this.currency,
    required this.paymentLinkId,
    required this.status,
    this.expiredAt,
    required this.checkoutUrl,
    required this.qrCode,
  });

  // Phương thức để chuyển JSON thành đối tượng Dart
  factory CheckoutPackageFee.fromJson(Map<String, dynamic> json) {
    return CheckoutPackageFee(
      bin: json['bin'],
      accountNumber: json['accountNumber'],
      amount: json['amount'],
      description: json['description'],
      orderCode: json['orderCode'],
      currency: json['currency'],
      paymentLinkId: json['paymentLinkId'],
      status: json['status'],
      expiredAt: json['expiredAt'],
      checkoutUrl: json['checkoutUrl'],
      qrCode: json['qrCode'],
    );
  }

  // Phương thức để chuyển đối tượng Dart thành JSON
  Map<String, dynamic> toJson() {
    return {
      'bin': bin,
      'accountNumber': accountNumber,
      'amount': amount,
      'description': description,
      'orderCode': orderCode,
      'currency': currency,
      'paymentLinkId': paymentLinkId,
      'status': status,
      'expiredAt': expiredAt,
      'checkoutUrl': checkoutUrl,
      'qrCode': qrCode,
    };
  }
}
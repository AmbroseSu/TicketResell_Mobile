class Ticket {
  final int id;
  final String ticketName;
  final int price;
  final int quantity;
  final String expirationDate;
  final String venue;
  final int status;
  final String categoryName;
  final int postId;
  final String postTitle;
  final String postDescription;
  final String createdDate;
  final bool postStatus;
  final int userId;
  final String email;

  Ticket({
    required this.id,
    required this.ticketName,
    required this.price,
    required this.quantity,
    required this.expirationDate,
    required this.venue,
    required this.status,
    required this.categoryName,
    required this.postId,
    required this.postTitle,
    required this.postDescription,
    required this.createdDate,
    required this.postStatus,
    required this.userId,
    required this.email,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json['id'],
        ticketName: json['ticketName'],
        price: json['price'],
        quantity: json['quantity'],
        expirationDate: json['expirationDate'],
        venue: json['venue'],
        status: json['status'],
        categoryName: json['categoryName'],
        postId: json['postId'],
        postTitle: json['postTitle'],
        postDescription: json['postDescription'],
        createdDate: json['createdDate'],
        postStatus: json['postStatus'],
        userId: json['userId'],
        email: json['email']);
  }
}

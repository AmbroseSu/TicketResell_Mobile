class Ticket {
  final int id;
  final String ticketName;
  final int price;
  final int quantity;
  final String expirationDate;
  final String venue;
  final int status;
  final int categoryId;
  final String categoryName;
  final String postTitle;
  final String postDescription;
  final String createdDate;
  final int userId;
  final String email;
  final List<String> imageUrls;

  Ticket({
    required this.id,
    required this.ticketName,
    required this.price,
    required this.quantity,
    required this.expirationDate,
    required this.venue,
    required this.status,
    required this.categoryId,
    required this.categoryName,
    required this.postTitle,
    required this.postDescription,
    required this.createdDate,
    required this.userId,
    required this.email,
    required this.imageUrls,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = (json['imageTicketDTOs'] as List)
        .map((image) => image['imageUrl'] as String)
        .toList();
    return Ticket(
      id: json['id'],
      ticketName: json['ticketName'],
      price: json['price'],
      quantity: json['quantity'],
      expirationDate: json['expirationDate'],
      venue: json['venue'],
      status: json['status'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      postTitle: json['postTitle'],
      postDescription: json['postDescription'],
      createdDate: json['createdDate'],
      userId: json['userId'],
      email: json['email'],
      imageUrls: imageUrls,
    );
  }
}

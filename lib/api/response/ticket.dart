import 'feedback.dart';

class Ticket {
  final int ticketId;
  final String ticketName;
  final int price;
  final int quantity;
  final String expirationDate;
  final String venue;
  final String status;
  final bool isDeleted;
  final int categoryId;
  final String categoryName;
  final int postId;
  final String postTitle;
  final String postDescription;
  final String currentPostStatus;
  final String createdDate;
  final int userId;
  final String email;
  final List<String> imageUrls;
  final List<Feedback> feedbackDTOs;

  Ticket({
    required this.ticketId,
    required this.ticketName,
    required this.price,
    required this.quantity,
    required this.expirationDate,
    required this.venue,
    required this.status,
    required this.isDeleted,
    required this.categoryId,
    required this.categoryName,
    required this.postId,
    required this.postTitle,
    required this.postDescription,
    required this.currentPostStatus,
    required this.createdDate,
    required this.userId,
    required this.email,
    required this.imageUrls,
    required this.feedbackDTOs,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];

    if (json['imageTicketDTOs'] != null && json['imageTicketDTOs'] is List && (json['imageTicketDTOs'] as List).isNotEmpty) {
      imageUrls = (json['imageTicketDTOs'] as List)
          .map((image) => image['imageUrl'] as String)
          .toList();
    } else {
      imageUrls = ['https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg']; // Default image if null or empty
    }

    List<Feedback> feedbacks = [];
    if (json['feedbackDTOs'] != null) {
      feedbacks = (json['feedbackDTOs'] as List)
          .map((feedbackJson) => Feedback.fromJson(feedbackJson))
          .toList();
    }

    return Ticket(
      ticketId: json['id'],
      ticketName: json['ticketName'],
      price: json['price'],
      quantity: json['quantity'],
      expirationDate: json['expirationDate'],
      venue: json['venue'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      postId: json['postId'],
      postTitle: json['postTitle'],
      postDescription: json['postDescription'],
      currentPostStatus: json['currentPostStatus'],
      createdDate: json['createdDate'],
      userId: json['userId'],
      email: json['email'],
      imageUrls: imageUrls,
      feedbackDTOs: feedbacks,
    );
  }
}

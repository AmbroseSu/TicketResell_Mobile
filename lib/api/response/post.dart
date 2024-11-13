import 'package:ticket_resell/api/response/post_element.dart';

import 'feedback.dart';

class PostResponse {
  final List<PostElement> postElements;
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
  final int userId;
  final String email;
  final List<String> imageUrls;
  final List<Feedback> feedbackDTOs;

  PostResponse({
    required this.postElements,
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
    required this.userId,
    required this.email,
    required this.imageUrls,
    required this.feedbackDTOs,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
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
    return PostResponse(
      postElements: (json['postElements'] as List)
          .map((postJson) => PostElement.fromJson(postJson))
          .toList(),
      ticketId: json['ticketId'],
      ticketName: json['ticketName'],
      price: json['price'],
      quantity: json['quantity'],
      expirationDate: json['expirationDate'],
      venue: json['venue'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      userId: json['userId'],
      email: json['email'],
      imageUrls: imageUrls,
      feedbackDTOs: feedbacks,
    );
  }
}
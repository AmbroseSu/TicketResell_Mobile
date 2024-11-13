class Feedback {
  final int id;
  final int rating;
  final String context;
  final bool isDeleted;
  final int userId;
  final String fullName;
  final String createdDate;
  final List<String> feedbackImages;

  Feedback({
    required this.id,
    required this.rating,
    required this.context,
    required this.isDeleted,
    required this.userId,
    required this.fullName,
    required this.createdDate,
    required this.feedbackImages,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    List<String> feedbackImages = [];
    if (json['imgs'] != null) {
      feedbackImages = (json['imgs'] as List)
          .map((img) => img['imageUrl'] as String)
          .toList();
    }else{
      feedbackImages = ['https://i.pinimg.com/736x/d7/07/84/d70784b885602af2877dd7a7230bba2c.jpg']; // Default image if null or empty

    }

    return Feedback(
      id: json['id'] ?? 0,
      rating: json['rating'] ?? 0,
      context: json['context'] ?? "",
      isDeleted: json['isDeleted'] ?? "",
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? "",
      createdDate: json['createdDate'] ?? "",
      feedbackImages: feedbackImages,
    );
  }
}
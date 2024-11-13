class PostElement {
  final int id;
  final String title;
  final String description;
  final String status;
  final bool isDeleted;
  final String createdDate;

  PostElement({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.isDeleted,
    required this.createdDate,
  });

  factory PostElement.fromJson(Map<String, dynamic> json) {
    return PostElement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      createdDate: json['createdDate'],
    );
  }
}
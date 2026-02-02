
class CommentModel {
  final String userId;
  final String text;
  final String createdAt;

  CommentModel({
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      text: map['text'],
      createdAt: map['createdAt'],
    );
  }
}
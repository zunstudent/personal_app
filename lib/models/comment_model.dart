import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final Timestamp? createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    this.createdAt,
  });

  factory CommentModel.fromMap(String id, Map<String, dynamic> map) {
    return CommentModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'User',
      text: map['text'] ?? '',
      createdAt: map['createdAt'] as Timestamp?,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String desc;
  final List<String> likes;
  final Timestamp? createdAt;
  final String userName;

  PostModel({
    required this.id,
    required this.userId,
    required this.desc,
    required this.likes,
    this.createdAt,
    required this.userName,
  });

  factory PostModel.fromMap(String id, Map<String, dynamic> map) {
    return PostModel(
      id: id,
      userId: map['userId'] ?? '',
      desc: map['desc'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: map['createdAt'] as Timestamp?,
      userName: map['userName'] ?? '',
    );
  }
}

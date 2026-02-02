import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
    final String userId;
    final String name;
    final String email; 
    final String? bio;

    UserModel({
        required this.userId,
        required this.name,
        required this.email,
        required this.bio
    });

    factory UserModel.fromMap(String id, Map<String, dynamic> map) {
        return UserModel(
            userId: id,
            name: map['name'],
            email: map['email'],
            bio: map['bio'],
        );
    }


}
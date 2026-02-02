import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/post_model.dart';

class FeedController extends GetxController {
  final posts = <PostModel>[].obs;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void onInit() {
    fetchPosts();
    super.onInit();
  }

  void fetchPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      posts.value = snapshot.docs
          .map((doc) => PostModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  void toggleLike(PostModel post) {
    final ref =
        FirebaseFirestore.instance.collection('posts').doc(post.id);

    if (post.likes.contains(uid)) {
      ref.update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      ref.update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}

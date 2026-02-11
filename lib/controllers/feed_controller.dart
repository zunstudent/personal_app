import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/post_model.dart';
import '../models/comment_model.dart';

class FeedController extends GetxController {
  final posts = <PostModel>[].obs;
  final userNames = <String, String>{}.obs; // Cache for user names
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final RxString currentUserRole = 'user'.obs;

  @override
  void onInit() {
    fetchPosts();
    fetchCurrentUserRole();
    super.onInit();
  }

  Future<void> fetchCurrentUserRole() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        currentUserRole.value = doc.data()?['role'] ?? 'user';
      }
    } catch (e) {
      print("Error fetching user role: $e");
    }
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

          // After fetching posts, fetch user names for missing userNames only
          for (var post in posts) {
            if (post.userName.isEmpty && !userNames.containsKey(post.userId)) {
              fetchUserName(post.userId);
            }
          }
        });
  }

  Future<void> fetchUserName(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists && doc.data() != null) {
        userNames[userId] = doc.data()!['name'] ?? 'Unknown User';
      } else {
        userNames[userId] = 'Unknown User';
      }
    } catch (e) {
      userNames[userId] = 'User';
    }
  }

  void toggleLike(PostModel post) {
    final ref = FirebaseFirestore.instance.collection('posts').doc(post.id);

    if (post.likes.contains(uid)) {
      ref.update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      ref.update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Future<bool> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      return true;
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus post: $e");
      return false;
    }
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => CommentModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  Future<void> addComment(String postId, String text) async {
    if (text.trim().isEmpty) return;
    try {
      // Fetch current user name
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final userName = userDoc.data()?['name'] ?? 'User';

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
            'userId': uid,
            'userName': userName,
            'text': text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim komentar: $e");
    }
  }
}

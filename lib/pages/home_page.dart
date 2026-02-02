import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_app/pages/add_post_page.dart';

import '../controllers/feed_controller.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final controller = Get.find<FeedController>();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(AppRoutes.profile),
          )
        ],
      ),

      body: Obx(() {
        if (controller.posts.isEmpty) {
          return const Center(child: Text('Belum ada postingan'));
        }

        return ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            final isLiked = post.likes.contains(uid);

            return Card(
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.desc,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () =>
                              controller.toggleLike(post),
                        ),
                        Text('${post.likes.length}'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // nanti ke halaman comment
                          },
                          child: const Text('Comment'),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage()));
          // nanti ke add post
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

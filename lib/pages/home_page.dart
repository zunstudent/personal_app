import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text(
          'Personal App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                Get.toNamed(AppRoutes.profile);
              } else if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.login);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.blueAccent),
                    SizedBox(width: 12),
                    Text('My Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Obx(() {
        if (controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.maps_ugc_outlined,
                    size: 60,
                    color: Colors.blueAccent.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to share something!',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            final isLiked = post.likes.contains(uid);
            final userName = post.userName.isNotEmpty
                ? post.userName
                : (controller.userNames[post.userId] ?? 'User');

            String formattedDate = '';
            if (post.createdAt != null) {
              formattedDate = DateFormat(
                'dd MMM, HH:mm',
              ).format(post.createdAt!.toDate());
            }

            return InkWell(
              onTap: () => Get.toNamed(AppRoutes.postDetail, arguments: post),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Avatar + Name + Date + Delete
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Get.toNamed(
                              AppRoutes.profile,
                              arguments: post.userId,
                            ),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blueAccent.withOpacity(
                                0.1,
                              ),
                              child: Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => Get.toNamed(
                                    AppRoutes.profile,
                                    arguments: post.userId,
                                  ),
                                  child: Text(
                                    userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (formattedDate.isNotEmpty)
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (post.userId == uid ||
                              controller.currentUserRole.value == 'admin')
                            IconButton(
                              icon: const Icon(
                                Icons.more_horiz,
                                color: Colors.grey,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Delete Post",
                                  titleStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  middleText:
                                      "Are you sure you want to delete this post?",
                                  textConfirm: "Delete",
                                  textCancel: "Cancel",
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.redAccent,
                                  cancelTextColor: Colors.grey[600],
                                  radius: 12,
                                  onConfirm: () {
                                    controller.deletePost(post.id);
                                    Get.back();
                                  },
                                );
                              },
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Content
                      Text(
                        post.desc,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),
                      Divider(color: Colors.grey[100], height: 1),
                      const SizedBox(height: 12),

                      // Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => controller.toggleLike(post),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isLiked
                                        ? Colors.redAccent
                                        : Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${post.likes.length}',
                                    style: TextStyle(
                                      color: isLiked
                                          ? Colors.redAccent
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: () => Get.toNamed(
                              AppRoutes.postDetail,
                              arguments: post,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Comment',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Share or more Button placeholder
                          Icon(
                            Icons.share_outlined,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(AddPostPage());
        },
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'New Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

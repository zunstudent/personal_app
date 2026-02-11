import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({super.key});

  final TextEditingController descC = TextEditingController();

  // Gunakan getter agar selalu mengambil UID terbaru
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> submitPost() async {
    final text = descC.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        "Error",
        "Isi postingan tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (uid.isEmpty) {
      Get.snackbar(
        "Error",
        "Kamu harus login terlebih dahulu",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Tampilkan Loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Ambil data user terlebih dahulu
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final userData = userDoc.data();
      final String userName = userData?['name'] ?? 'User';

      // KIRIM DATA KE FIRESTORE (AWAIT SANGAT PENTING!)
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': uid,
        'desc': text,
        'likes': [],
        'createdAt': FieldValue.serverTimestamp(),
        'userName': userName,
      });

      // Tutup Loading
      Get.back();

      // Kembali ke Home
      Get.back();

      Get.snackbar(
        "Sukses",
        "Postingan berhasil disimpan ke Firebase",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Tutup Loading jika error
      if (Get.isDialogOpen!) Get.back();

      print("FIRESTORE ERROR: $e");
      Get.snackbar(
        "Gagal",
        "Error: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: descC,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                filled: true,
                fillColor: Colors.grey[50], // Very light grey
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(24),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (descC.text.isNotEmpty) {
                    submitPost();
                  } else {
                    Get.snackbar(
                      "Alert",
                      "Please write something first",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.withOpacity(0.8),
                      colorText: Colors.white,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded),
                    SizedBox(width: 12),
                    Text(
                      'POST',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

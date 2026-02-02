import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddPostPage extends StatelessWidget {
  AddPostPage({super.key});

  final TextEditingController descC = TextEditingController();
  // Gunakan getter agar selalu mengambil UID terbaru saat fungsi dipanggil
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  void submitPost() async {
    final text = descC.text.trim();
    if (text.isEmpty) {
      Get.snackbar("Error", "Isi postingan tidak boleh kosong");
      return;
    }

    try {
      // Tampilkan loading sederhana agar user tidak klik tombol berkali-kali
      Get.showOverlay(
        asyncFunction: () async {
          await FirebaseFirestore.instance.collection('posts').add({
            'userId': uid,
            'desc': text,
            'likes': [],
            'createdAt': FieldValue.serverTimestamp(), // Sangat penting untuk urutan di Home
          });
        },
        loadingWidget: const Center(child: CircularProgressIndicator()),
      );

      // Setelah berhasil, Get.back() akan menutup halaman ini
      Get.back(); 
      Get.snackbar("Sukses", "Postingan berhasil dibagikan");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengirim postingan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Postingan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: descC,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Apa yang kamu pikirkan?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitPost,
                child: const Text('Posting'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- CONTROLLER ---
class ProfileController extends GetxController {
  // Instance Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Variabel reaktif
  var username = "".obs;
  var email = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    // Mengambil data dari user yang sedang login di Firebase
    final user = _auth.currentUser;
    if (user != null) {
      email.value = user.email ?? "Email tidak ditemukan";
      username.value = user.displayName ?? "User Baru";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login'); // Kembali ke halaman login setelah logout
  }
}

// --- VIEW ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            // Menampilkan Nama dari Firebase
            Obx(() => Text(
                  controller.username.value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
            
            // Menampilkan Email dari Firebase
            Obx(() => Text(
                  controller.email.value,
                  style: const TextStyle(color: Colors.grey),
                )),
            
            const SizedBox(height: 30),
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text("Status Akun"),
              subtitle: const Text("Aktif"),
            ),
            
            const Spacer(),
            
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => controller.logout(),
              icon: const Icon(Icons.exit_to_app),
              label: const Text("Keluar dari Aplikasi"),
            ),
          ],
        ),
      ),
    );
  }
}
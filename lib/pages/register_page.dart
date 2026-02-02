import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();
  final TextEditingController nameC = TextEditingController();

  final auth = Get.find<AuthController>();

  void register() async {
    if (emailC.text.isEmpty ||
        passC.text.isEmpty ||
        nameC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await auth.register(emailC.text.trim(), passC.text.trim());

      // Simpan data user ke Firestore
      await auth.createUserProfile(nameC.text.trim());

    } catch (e) {
      Get.snackbar(
        'Register gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: register,
                child: const Text('Register'),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Sudah punya akun? Login'),
            )
          ],
        ),
      ),
    );
  }
}

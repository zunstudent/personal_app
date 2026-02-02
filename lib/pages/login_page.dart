import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailC = TextEditingController();
  final passC = TextEditingController();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                auth.login(emailC.text, passC.text);
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.register);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

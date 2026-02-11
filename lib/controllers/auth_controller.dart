import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);
    super.onInit();
  }

  void _handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      _checkUserRoleAndNavigate(user);
    }
  }

  Future<void> _checkUserRoleAndNavigate(User user) async {
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final role = doc.data()!['role'] ?? 'user';
        if (role == 'admin') {
          Get.offAllNamed(AppRoutes.adminHome);
        } else {
          Get.offAllNamed(AppRoutes.home);
        }
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      // Fallback or error handling 
      Get.offAllNamed(AppRoutes.home);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Email dan password tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login gagal';

      switch (e.code) {
        case 'user-not-found':
          message = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Email atau password salah';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'user-disabled':
          message = 'Akun ini telah dinonaktifkan';
          break;
        case 'too-many-requests':
          message = 'Terlalu banyak percobaan. Coba lagi nanti';
          break;
        default:
          message = 'Login gagal: ${e.message}';
      }

      Get.snackbar(
        'Login Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> register(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Email dan password tidak boleh kosong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      if (password.length < 6) {
        Get.snackbar(
          'Error',
          'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return;
      }

      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Registrasi gagal';

      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          message = 'Format email tidak valid';
          break;
        case 'weak-password':
          message = 'Password terlalu lemah';
          break;
        case 'operation-not-allowed':
          message = 'Registrasi tidak diizinkan';
          break;
        default:
          message = 'Registrasi gagal: ${e.message}';
      }

      Get.snackbar(
        'Registrasi Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> createUserProfile(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'role': 'user', // Default role
      'email': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

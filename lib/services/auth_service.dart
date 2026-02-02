import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream auth state (login / logout)
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  /// Login
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /// Register
  Future<User?> register({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;
}

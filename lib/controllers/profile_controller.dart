import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rxn<UserModel> userProfile = Rxn<UserModel>();
  var isLoading = false.obs;

  // To check if the profile belongs to the logged in user
  bool get isCurrentUser => userProfile.value?.userId == _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    // Check if we passed a specific userId to view
    final String? userId = Get.arguments as String?;
    loadUserData(userId);
  }

  void loadUserData(String? userId) async {
    isLoading.value = true;
    try {
      // Use provided userId or fallback to current logged in user
      final uid = userId ?? _auth.currentUser?.uid;

      if (uid != null) {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          userProfile.value = UserModel.fromMap(uid, doc.data()!);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat profil');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}

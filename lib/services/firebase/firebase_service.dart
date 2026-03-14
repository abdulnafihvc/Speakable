import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Firebase initialization and dependency injection wrapper
class FirebaseService extends GetxService {
  // Observable authentication state
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isInitialized = false.obs;

  /// Initialize Firebase
  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      isInitialized.value = true;

      // Listen to auth state changes
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        currentUser.value = user;
      });

      // Set initial user
      currentUser.value = FirebaseAuth.instance.currentUser;
    } catch (e) {
      Get.snackbar('Firebase Error', 'Failed to initialize: ${e.toString()}');
    }
  }

  /// Get Firebase Auth instance
  FirebaseAuth get auth => FirebaseAuth.instance;

  /// Check if user is signed in
  bool get isSignedIn => currentUser.value != null;

  /// Get current user ID
  String? get userId => currentUser.value?.uid;

  /// Get current user email
  String? get userEmail => currentUser.value?.email;

  /// Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

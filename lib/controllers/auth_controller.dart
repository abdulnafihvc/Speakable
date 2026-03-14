import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/screen/home/screen/home_screen.dart';
import 'package:speakable/screen/login/screen/login_screen.dart';
import 'package:speakable/screen/voice_selection/voice_selection_screen.dart';
import 'package:speakable/services/voice_settings_service.dart';
import 'package:speakable/utils/error_handler.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  // Flag to prevent auto-navigation during splash screen
  bool _splashCompleted = false;

  User? get user => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser.bindStream(_auth.authStateChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  /// Call this method when splash screen animation is complete
  void markSplashComplete() {
    _splashCompleted = true;
  }

  void _setInitialScreen(User? user) async {
    // Don't navigate automatically if splash hasn't completed yet
    // The splash screen will handle the initial navigation
    if (!_splashCompleted) return;

    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      final voiceSettings = Get.find<VoiceSettingsService>();
      final isSetupComplete = await voiceSettings.isFirstTimeSetupComplete();

      if (isSetupComplete) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const VoiceSelectionScreen());
      }
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      Get.snackbar(
        'Account Created', 
        AppErrorMessages.signUpSuccess,
        colorText: Colors.white, 
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Registration Failed', 
        ErrorHandler.getAuthErrorMessage(e),
        colorText: Colors.white, 
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Registration Failed', 
        AppErrorMessages.unexpectedError,
        colorText: Colors.white, 
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // _setInitialScreen will be called automatically due to the listener
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Sign In Failed', 
        ErrorHandler.getAuthErrorMessage(e),
        colorText: Colors.white, 
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Sign In Failed', 
        AppErrorMessages.unexpectedError,
        colorText: Colors.white, 
        backgroundColor: Colors.red,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

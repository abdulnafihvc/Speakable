import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speakable/screen/home/screen/home_screen.dart';
import 'package:speakable/screen/login/screen/login_screen.dart';
import 'package:speakable/screen/voice_selection/voice_selection_screen.dart';
import 'package:speakable/services/voice_settings_service.dart';

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
      Get.snackbar('Success', 'Account created successfully',
          colorText: Colors.white, backgroundColor: Colors.green);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Sign up failed',
          colorText: Colors.white, backgroundColor: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          colorText: Colors.white, backgroundColor: Colors.red);
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
      Get.snackbar('Error', e.message ?? 'Login failed',
          colorText: Colors.white, backgroundColor: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred',
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
 
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

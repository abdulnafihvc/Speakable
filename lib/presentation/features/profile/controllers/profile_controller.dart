import 'package:get/get.dart';
import 'package:speakable/services/firebase/firebase_service.dart';
import 'package:speakable/services/storage/shared_prefs_service.dart';
import 'package:speakable/services/speech/tts_service.dart';

/// Profile controller demonstrating Clean Architecture with GetX
class ProfileController extends GetxController {
  // Inject services using GetX
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final SharedPrefsService _prefsService = Get.find<SharedPrefsService>();
  final TtsService _ttsService = Get.find<TtsService>();

  // Observable states
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt profileViews = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Load user data from Firebase and local storage
  Future<void> _loadUserData() async {
    isLoading.value = true;

    try {
      // Get user from Firebase
      userEmail.value = _firebaseService.userEmail ?? 'No email';

      // Load user name from SharedPreferences
      final savedName = _prefsService.getString('user_name');
      userName.value = savedName ?? 'Guest User';

      // Load profile views count
      final views = _prefsService.getInt('profile_views') ?? 0;
      profileViews.value = views;

      // Increment profile views
      await _incrementProfileViews();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Increment profile views counter
  Future<void> _incrementProfileViews() async {
    profileViews.value++;
    await _prefsService.setInt('profile_views', profileViews.value);
  }

  /// Update user name
  Future<void> updateUserName(String newName) async {
    if (newName.trim().isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty');
      return;
    }

    isLoading.value = true;

    try {
      userName.value = newName;
      await _prefsService.setString('user_name', newName);
      Get.snackbar('Success', 'Name updated successfully');

      // Speak confirmation using TTS
      await _ttsService.speak('Name updated to $newName');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Speak user profile details
  Future<void> speakProfile() async {
    final message = 'Your profile: $userName, $userEmail. '
        'Profile views: ${profileViews.value}';
    await _ttsService.speak(message);
  }

  /// Clear profile data
  Future<void> clearProfileData() async {
    Get.defaultDialog(
      title: 'Clear Profile',
      middleText: 'Are you sure you want to clear all profile data?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        await _prefsService.remove('user_name');
        await _prefsService.remove('profile_views');
        userName.value = 'Guest User';
        profileViews.value = 0;
        Get.back();
        Get.snackbar('Success', 'Profile data cleared');
      },
    );
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}

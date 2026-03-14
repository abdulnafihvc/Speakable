import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speakable/controllers/auth_controller.dart';
import 'package:speakable/controllers/theme_controller.dart';
import 'package:speakable/models/user_document.dart';
import 'package:speakable/screen/login/screen/splash_screen.dart';
import 'package:speakable/utils/app_theme.dart';
import 'package:speakable/services/voice_settings_service.dart';

// Import new service layer
import 'package:speakable/services/firebase/firebase_service.dart';
import 'package:speakable/services/storage/hive_storage_service.dart';
import 'package:speakable/services/storage/shared_prefs_service.dart';
import 'package:speakable/services/speech/tts_service.dart';
import 'package:speakable/services/speech/stt_service.dart';
import 'package:speakable/services/audio/audio_player_service.dart';
import 'package:speakable/services/api/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure fullscreen mode - hide status bar and navigation bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
    overlays: [],
  );

  // Configure system UI overlay style for transparency
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // ==================== Storage Layer Initialization ====================
  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  HiveStorageService.registerAdapter(UserDocumentAdapter());

  // Open Hive boxes
  await Hive.openBox<UserDocument>('documents');

  // Initialize SharedPreferences service
  final sharedPrefs = SharedPrefsService();
  await sharedPrefs.init();
  Get.put(sharedPrefs, permanent: true);

  // Initialize Hive storage service
  final hiveStorage = HiveStorageService(boxName: 'app_storage');
  await hiveStorage.init();
  Get.put(hiveStorage, permanent: true);

  // ==================== Firebase Initialization ====================
  final firebaseService = FirebaseService();
  await firebaseService.init();
  Get.put(firebaseService, permanent: true);

  // ==================== Service Layer Initialization ====================
  // Initialize TTS service
  Get.put(TtsService(), permanent: true);

  // Initialize STT service
  Get.put(SttService(), permanent: true);

  // Initialize Audio Player service
  Get.put(AudioPlayerService(), permanent: true);

  // Initialize API service (configure base URL as needed)
  Get.put(
    ApiService(baseUrl: 'https://api.example.com'),
    permanent: true,
  );

  // ==================== Controllers Initialization ====================
  // Initialize theme controller
  Get.put(ThemeController());

  // Initialize Auth Controller
  Get.put(AuthController());

  // Initialize voice settings service (existing)
  Get.put(VoiceSettingsService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speakable',
      // Material 3 enabled theme
      theme: AppTheme.lightTheme.copyWith(
        useMaterial3: true,
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

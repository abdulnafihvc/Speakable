import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speakable/controllers/theme_controller.dart';
import 'package:speakable/models/user_document.dart';
import 'package:speakable/screen/login/screen/splash_screen.dart';
import 'package:speakable/utils/app_theme.dart';
import 'package:speakable/services/voice_settings_service.dart';

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
      statusBarIconBrightness: Brightness.light, // For light status bar icons
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(UserDocumentAdapter());

  // Open Hive boxes
  await Hive.openBox<UserDocument>('documents');

  // Initialize theme controller
  Get.put(ThemeController());

  // Initialize voice settings service
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

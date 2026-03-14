import 'package:speech_to_text/speech_to_text.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Speech-to-Text service integration
class SttService extends GetxService {
  final SpeechToText _speech = SpeechToText();

  // Observable states
  final RxBool isListening = false.obs;
  final RxBool isAvailable = false.obs;
  final RxString recognizedText = ''.obs;
  final RxDouble confidenceLevel = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeStt();
  }

  /// Initialize STT
  Future<void> _initializeStt() async {
    // Request microphone permission
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      isAvailable.value = await _speech.initialize(
        onError: (error) {
          isListening.value = false;
          Get.snackbar('Speech Error', error.errorMsg);
        },
        onStatus: (status) {
          isListening.value = status == 'listening';
        },
      );
    } else {
      Get.snackbar(
        'Permission Denied',
        'Microphone permission is required for speech recognition',
      );
    }
  }

  /// Start listening
  Future<void> startListening({
    Function(String)? onResult,
    String localeId = 'en_US',
  }) async {
    if (!isAvailable.value) {
      Get.snackbar('Error', 'Speech recognition is not available');
      return;
    }

    if (isListening.value) {
      await stopListening();
    }

    await _speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        confidenceLevel.value = result.confidence;
        onResult?.call(result.recognizedWords);
      },
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
      ),
    );
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
    isListening.value = false;
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    await _speech.cancel();
    isListening.value = false;
    recognizedText.value = '';
  }

  /// Get available locales
  Future<List<LocaleName>> getLocales() async {
    return await _speech.locales();
  }

  /// Check if speech recognition is available
  Future<bool> checkAvailability() async {
    return await _speech.initialize();
  }

  @override
  void onClose() {
    _speech.stop();
    super.onClose();
  }
}

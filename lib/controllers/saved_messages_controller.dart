import 'package:speakable/services/google_tts_service.dart';
import 'package:get/get.dart';
import 'package:speakable/models/saved_message.dart';
import 'package:speakable/services/message_storage_service.dart';

class SavedMessagesController extends GetxController {
  final MessageStorageService _storageService = MessageStorageService();
  late GoogleTtsService flutterTts;

  var messages = <SavedMessage>[].obs;
  var playingMessageId = Rxn<String>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
    loadMessages();
  }

  void _initTts() {
    flutterTts = GoogleTtsService();

    flutterTts.setCompletionHandler(() {
      playingMessageId.value = null;
    });

    flutterTts.setErrorHandler((msg) {
      playingMessageId.value = null;
    });
  }

  Future<void> loadMessages() async {
    isLoading.value = true;
    final loadedMessages = await _storageService.getSavedMessages();
    messages.value = loadedMessages;
    isLoading.value = false;
  }

  Future<void> playMessage(SavedMessage message) async {
    if (playingMessageId.value == message.id) {
      await flutterTts.stop();
      playingMessageId.value = null;
    } else {
      await flutterTts.stop();
      playingMessageId.value = message.id;
      await flutterTts.speak(text: message.text, languageCode: 'en-US');
    }
  }

  Future<void> deleteMessage(SavedMessage message) async {
    if (playingMessageId.value == message.id) {
      await flutterTts.stop();
      playingMessageId.value = null;
    }

    await _storageService.deleteMessage(message.id);
    await loadMessages();

    Get.snackbar(
      'Deleted',
      'Message deleted',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> clearAllMessages() async {
    await flutterTts.stop();
    await _storageService.clearAllMessages();
    await loadMessages();
  }

  @override
  void onClose() {
    flutterTts.dispose();
    super.onClose();
  }
}

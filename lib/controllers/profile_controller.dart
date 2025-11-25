import 'package:get/get.dart';
import 'package:speakable/services/message_storage_service.dart';
import 'package:speakable/services/emotion_storage_service.dart';

class ProfileController extends GetxController {
  final MessageStorageService _messageService = MessageStorageService();
  final EmotionStorageService _emotionService = EmotionStorageService();
  
  var userName = 'User'.obs;
  var savedMessagesCount = 0.obs;
  var customEmotionsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    final messages = await _messageService.getSavedMessages();
    final emotions = await _emotionService.getCustomEmotions();
    
    savedMessagesCount.value = messages.length;
    customEmotionsCount.value = emotions.length;
  }

  void updateUserName(String name) {
    userName.value = name.isNotEmpty ? name : 'User';
  }
}

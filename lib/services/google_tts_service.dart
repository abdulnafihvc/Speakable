import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:speakable/services/voice_settings_service.dart';

/// Google Cloud Text-to-Speech Service
/// Professional version using Google Cloud TTS REST API
class GoogleTtsService {
  // TODO: Replace with your actual Google Cloud API key
  static const String _apiKey = 'YOUR_GOOGLE_CLOUD_API_KEY_HERE';
  static const String _baseUrl =
      'https://texttospeech.googleapis.com/v1/text:synthesize';

  final AudioPlayer _audioPlayer = AudioPlayer();
  final VoiceSettingsService _voiceSettings = Get.find<VoiceSettingsService>();

  String? _currentAudioPath;
  bool _isPlaying = false;

  // Callbacks for state management
  Function()? _onStart;
  Function()? _onComplete;
  Function(String)? _onError;

  /// Voice configurations for different languages and genders
  Map<String, Map<String, String>> get _voiceConfig => {
    'en-US': {'male': 'en-US-Neural2-D', 'female': 'en-US-Neural2-F'},
    'ml-IN': {'male': 'ml-IN-Wavenet-B', 'female': 'ml-IN-Wavenet-A'},
  };

  /// Set callback for when speech starts
  void setStartHandler(Function() handler) {
    _onStart = handler;
  }

  /// Set callback for when speech completes
  void setCompletionHandler(Function() handler) {
    _onComplete = handler;
  }

  /// Set callback for errors
  void setErrorHandler(Function(String) handler) {
    _onError = handler;
  }

  /// Synthesize and speak text using Google Cloud TTS
  Future<void> speak({required String text, String? languageCode}) async {
    if (text.isEmpty) return;

    try {
      _isPlaying = true;
      _onStart?.call();

      // Get current voice settings
      final voiceGender = _voiceSettings.voiceGender.value;
      final language = languageCode ?? 'en-US';

      // Select appropriate voice based on language and gender
      final voiceName =
          _voiceConfig[language]?[voiceGender] ??
          _voiceConfig['en-US']![voiceGender]!;

      // Prepare request body
      final requestBody = {
        'input': {'text': text},
        'voice': {'languageCode': language, 'name': voiceName},
        'audioConfig': {
          'audioEncoding': 'MP3',
          'pitch': _voiceSettings.pitch.value,
          'speakingRate': _voiceSettings.speechRate.value,
          'volumeGainDb': _convertVolumeToDb(_voiceSettings.volume.value),
        },
      };

      // Make API request
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final audioContent = responseData['audioContent'] as String;

        // Decode base64 audio and save to temp file
        final audioBytes = base64.decode(audioContent);
        final tempDir = await getTemporaryDirectory();
        final audioFile = File(
          '${tempDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3',
        );
        await audioFile.writeAsBytes(audioBytes);

        _currentAudioPath = audioFile.path;

        // Play audio
        await _audioPlayer.play(DeviceFileSource(audioFile.path));

        // Listen for completion
        _audioPlayer.onPlayerComplete.listen((_) {
          _isPlaying = false;
          _onComplete?.call();
          _cleanupAudioFile();
        });
      } else {
        final error = json.decode(response.body);
        throw Exception('TTS API Error: ${error['error']['message']}');
      }
    } catch (e) {
      _isPlaying = false;
      _onError?.call(e.toString());
      _onComplete?.call();
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
      _onComplete?.call();
      _cleanupAudioFile();
    }
  }

  /// Convert volume (0.0-1.0) to decibels for Google TTS
  double _convertVolumeToDb(double volume) {
    // Convert 0.0-1.0 range to -20.0 to +20.0 dB range
    return (volume - 0.5) * 40.0;
  }

  /// Clean up temporary audio file
  Future<void> _cleanupAudioFile() async {
    if (_currentAudioPath != null) {
      try {
        final file = File(_currentAudioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
      }
      _currentAudioPath = null;
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
  }

  /// Check if currently speaking
  bool get isSpeaking => _isPlaying;
}

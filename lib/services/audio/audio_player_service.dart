import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

/// Audio player service with proper lifecycle handling
class AudioPlayerService extends GetxService {
  final AudioPlayer _player = AudioPlayer();

  // Observable states
  final RxBool isPlaying = false.obs;
  final Rx<PlayerState> playerState = PlayerState.stopped.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final RxDouble volume = 1.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    _setupListeners();
  }

  /// Setup audio player listeners
  void _setupListeners() {
    // Listen to player state changes
    _player.onPlayerStateChanged.listen((state) {
      playerState.value = state;
      isPlaying.value = state == PlayerState.playing;
    });

    // Listen to duration changes
    _player.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });

    // Listen to position changes
    _player.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });

    // Listen to completion
    _player.onPlayerComplete.listen((_) {
      position.value = Duration.zero;
      isPlaying.value = false;
    });
  }

  /// Play audio from URL
  Future<void> playFromUrl(String url) async {
    try {
      await _player.play(UrlSource(url));
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: ${e.toString()}');
    }
  }

  /// Play audio from asset
  Future<void> playFromAsset(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: ${e.toString()}');
    }
  }

  /// Play audio from file path
  Future<void> playFromFile(String filePath) async {
    try {
      await _player.play(DeviceFileSource(filePath));
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: ${e.toString()}');
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.resume();
  }

  /// Stop playback
  Future<void> stop() async {
    await _player.stop();
    position.value = Duration.zero;
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double value) async {
    volume.value = value.clamp(0.0, 1.0);
    await _player.setVolume(volume.value);
  }

  /// Set playback rate
  Future<void> setPlaybackRate(double rate) async {
    await _player.setPlaybackRate(rate);
  }

  /// Get current position as percentage
  double get positionPercentage {
    if (duration.value.inMilliseconds == 0) return 0.0;
    return position.value.inMilliseconds / duration.value.inMilliseconds;
  }

  /// Release resources
  Future<void> release() async {
    await _player.release();
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}

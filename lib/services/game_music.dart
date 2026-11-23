import 'package:audioplayers/audioplayers.dart';

class GameMusic {
  GameMusic._();
  static final GameMusic instance = GameMusic._();

  final AudioPlayer _player = AudioPlayer();
  bool _started = false;
  double _volume = 0.7;

  double get volume => _volume;

  Future<void> start() async {
    if (_started) return;
    _started = true;
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(_volume);
      await _player.play(AssetSource('audio/background_music.mp3'));
    } catch (error) {
      // Keep the game usable if the optional music asset has not been added yet.
      _started = false;
    }
  }

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    try {
      await _player.setVolume(_volume);
    } catch (_) {
      // The player may not have started until its asset is available.
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    _started = false;
  }
}

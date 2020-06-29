import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

const _IDLE = "idle.wav";
const _GAME_OVER = "game-over.wav";

final _idlePlayer = AudioPlayer(playerId: "idle", mode: PlayerMode.LOW_LATENCY);
final _player = AudioPlayer(playerId: "default", mode: PlayerMode.LOW_LATENCY);

final _idleCache = AudioCache(fixedPlayer: _idlePlayer);
final _cache = AudioCache(fixedPlayer: _player);

Future<void> playIdle() async {
  await _idlePlayer.stop();
  await _idleCache.loop(_IDLE);
}

void playGameOver() {
  _cache.play(_GAME_OVER);
}

import 'package:audio_service/audio_service.dart';

import '../utils/media_item_adapter.dart';
import 'audio_player.dart';

class AudioHandler extends BaseAudioHandler {
  new({required this._player}) {
    _player.stream.isPlaying.listen((_) => _updateState());
    _player.stream.currentTrack.listen((track) {
      final item = track?.toMediaItem();
      mediaItem.add(item);
      if (item != null) queue.add([item]);
      _updateState();
    });
  }

  final AudioPlayer _player;

  void _updateState() => playbackState.add(
    .new(
      controls: [
        .skipToPrevious,
        if (_player.isPlaying) .pause else .play,
        .skipToNext,
        .fastForward,
      ],
      processingState: .idle,
      systemActions: const {.skipToPrevious, .playPause, .skipToNext, .seek},
      androidCompactActionIndices: [0, 1, 2],
      updatePosition: _player.position,
      updateTime: DateTime.now(),
      playing: _player.isPlaying,
      bufferedPosition: _player.duration,
      shuffleMode: _player.isShuffled ? .all : .none,
      repeatMode: _player.isLooped ? .one : .all,
      speed: 1,
      queueIndex: 0,
    ),
  );

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> skipToNext() => _player.next();

  @override
  Future<void> skipToPrevious() => _player.previous();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}

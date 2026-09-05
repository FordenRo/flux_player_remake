import 'dart:async';
import 'dart:math';

import 'package:media_kit/media_kit.dart' as media_kit;

import '../models/playlist.dart';
import '../models/track.dart';

typedef AudioDevice = media_kit.AudioDevice;

final audioPlayer = AudioPlayer._();

class AudioPlayer {
  AudioPlayer._() {
    _player.stream.completed.listen((completed) {
      if (completed) _onEnd();
    });
  }

  final _player = media_kit.Player();

  List<Track> _queue = [];
  List<Track>? _originalQueue = [];
  Playlist? _currentPlaylist;
  int? _currentIndex;
  var _isShuffled = false;
  var _isLooped = false;

  bool get isPlaying => _player.state.playing;
  double get volume => _player.state.volume / 100;
  Duration get duration => _player.state.duration;
  Duration get position => _player.state.position;
  Duration get buffer => _player.state.buffer;
  bool get isShuffled => _isShuffled;
  bool get isLooped => _isLooped;
  List<Track> get queue => _queue;
  List<AudioDevice> get audioDevices => _player.state.audioDevices;
  AudioDevice get audioDevice => _player.state.audioDevice;
  int? get currentIndex => _currentIndex;
  Track? get currentTrack => currentIndex != null ? queue[currentIndex!] : null;
  Playlist? get currentPlaylist => _currentPlaylist;

  final StreamController<List<Track>> _queueController = .broadcast();
  final StreamController<Playlist?> _currentPlaylistController = .broadcast();
  final StreamController<int?> _currentIndexController = .broadcast();
  final StreamController<bool> _isShuffledController = .broadcast();
  final StreamController<bool> _isLoopedController = .broadcast();

  late final AudioPlayerStream stream = .new(
    volume: _player.stream.volume.map((e) => e / 100),
    currentIndex: _currentIndexController.stream.distinct(),
    queue: _queueController.stream,
    position: _player.stream.position,
    duration: _player.stream.duration,
    isPlaying: _player.stream.playing,
    isShuffled: _isShuffledController.stream.distinct(),
    currentTrack: _currentIndexController.stream.distinct().map(
      (e) => e != null ? queue[e] : null,
    ),
    isLooped: _isLoopedController.stream.distinct(),
    currentPlaylist: _currentPlaylistController.stream.distinct(),
    buffer: _player.stream.buffer,
    audioDevice: _player.stream.audioDevice,
  );

  Future<void> setVolume(double volume) =>
      _player.setVolume(max(min(volume, 1), 0) * 100);

  void setShuffled(bool shuffled, {bool shuffleQueue = true}) {
    if (shuffled && shuffleQueue) {
      final track = currentTrack;
      _originalQueue ??= List.of(queue);

      _queue.shuffle();
      if (track != null) {
        _currentIndex = _queue.indexOf(track);
        _currentIndexController.add(_currentIndex);
      }
    } else if (!shuffled) {
      final track = currentTrack;
      _queue = List.of(currentPlaylist ?? _originalQueue ?? []);
      _originalQueue = null;
      if (track != null) {
        if (_queue.indexOf(track) case final index when index != -1) {
          _currentIndex = index;
          _currentIndexController.add(_currentIndex);
        }
      }
    }
    _queueController.add(_queue);
    _isShuffled = shuffled;
    _isShuffledController.add(shuffled);
  }

  void setLooped(bool looped) {
    _isLooped = looped;
    _isLoopedController.add(looped);
  }

  Future<void> setPlaylist(
    Playlist playlist, {
    int? index,
    bool play = false,
  }) async {
    _currentPlaylist = playlist;
    _currentPlaylistController.add(_currentPlaylist);
    _queue = List.of(playlist);
    _queueController.add(_queue);
    if (index != null) {
      await jump(index, play: play);
    } else {
      _currentIndex = null;
      _currentIndexController.add(null);
    }
    setShuffled(isShuffled);
  }

  Future<void> setTrack(Track track, {bool play = true, bool load = true}) =>
      setQueue([track], play: play, load: load);

  Future<void> setQueue(
    List<Track> queue, {
    int? index,
    bool play = false,
    bool load = true,
  }) async {
    _queue = queue;
    _queueController.add(_queue);
    if (index != null) await setIndex(index, play: play, load: load);
  }

  Future<void> removeFromQueue(int index) async {
    _queue.removeAt(index);
    _queueController.add(_queue);
    if (currentIndex == index) {
      await setIndex(index, play: isPlaying);
    } else if (index < audioPlayer.currentIndex!) {
      await setIndex(audioPlayer.currentIndex! - 1, load: false);
    }
  }

  Future<void> addToQueue(Track track) async {
    _queue.add(track);
    _queueController.add(_queue);
    if (currentIndex == null) await setIndex(0, play: false);
  }

  Future<void> addAllToQueue(Iterable<Track> tracks) async {
    _queue.addAll(tracks);
    _queueController.add(_queue);
    if (currentIndex == null) await setIndex(0, play: false);
  }

  Future<void> addNext(Track track) async {
    _queue.insert((currentIndex ?? -1) + 1, track);
    _queueController.add(_queue);
    if (currentIndex == null) await setIndex(0, play: false);
  }

  Future<void> addAllToNext(Iterable<Track> tracks) async {
    _queue.insertAll((currentIndex ?? -1) + 1, tracks);
    _queueController.add(_queue);
    if (currentIndex == null) await setIndex(0, play: false);
  }

  Future<void> setAudioDevice(AudioDevice device) =>
      _player.setAudioDevice(device);

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> stop() {
    _currentPlaylist = null;
    _currentPlaylistController.add(null);
    _queue = [];
    _queueController.add([]);
    _currentIndex = null;
    _currentIndexController.add(null);
    return _player.stop();
  }

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> jump(int index, {bool play = true}) => setIndex(
    isShuffled ? queue.indexOf(currentPlaylist![index]) : index,
    play: play,
  );

  Future<void> setIndex(int index, {bool play = true, bool load = true}) async {
    if (index < 0 || index >= queue.length) index = index % queue.length;

    _currentIndex = index;
    _currentIndexController.add(index);
    if (load) {
      await _player.open(media_kit.Media(queue[index].path), play: play);
    }
  }

  Future<void> _onEnd() => isLooped ? play() : next();

  Future<void> next() => setIndex(currentIndex! + 1);

  Future<void> previous() => position.inSeconds > 10
      ? seek(Duration.zero)
      : setIndex(currentIndex! - 1);

  Future<void> dispose() => Future.wait([
    _player.dispose(),
    _queueController.close(),
    _currentPlaylistController.close(),
    _currentIndexController.close(),
    _isShuffledController.close(),
    _isLoopedController.close(),
  ]);
}

class AudioPlayerStream {
  new({
    required this.volume,
    required this.currentIndex,
    required this.queue,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isShuffled,
    required this.currentTrack,
    required this.isLooped,
    required this.currentPlaylist,
    required this.buffer,
    required this.audioDevice,
  });

  final Stream<double> volume;
  final Stream<int?> currentIndex;
  final Stream<List<Track>> queue;
  final Stream<Duration> position;
  final Stream<Duration> duration;
  final Stream<bool> isPlaying;
  final Stream<bool> isShuffled;
  final Stream<Track?> currentTrack;
  final Stream<bool> isLooped;
  final Stream<Playlist?> currentPlaylist;
  final Stream<Duration> buffer;
  final Stream<AudioDevice> audioDevice;
}

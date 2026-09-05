import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:window_manager/window_manager.dart';

import '../models/app_config.dart';
import '../services/audio_player.dart';
import 'library_repository.dart';

final configRepository = ConfigRepository._();

class ConfigRepository {
  ConfigRepository._();

  late ConfigStream stream = .new(page: _pageController.stream.distinct());

  var _page = 0;

  int get page => _page;
  set page(int value) {
    _page = value;
    _pageController.add(value);
  }

  final StreamController<int> _pageController = .broadcast();

  Future<void> apply(AppConfig config) async {
    if (config.page != null) page = config.page!;
    if (config.windowPosition != null) {
      await windowManager.setPosition(
        Offset(
          config.windowPosition!.x.toDouble(),
          config.windowPosition!.y.toDouble(),
        ),
      );
    }
    if (config.windowSize != null) {
      await windowManager.setSize(
        Size(config.windowSize!.x.toDouble(), config.windowSize!.y.toDouble()),
      );
    }
    if (config.libraryPaths != null) {
      libraryRepository.setPaths(config.libraryPaths!);
    }
    final device = config.device != null
        ? audioPlayer.audioDevices
              .where((e) => e.name == config.device)
              .firstOrNull
        : null;
    if (device != null) await audioPlayer.setAudioDevice(device);
    if (config.volume != null) await audioPlayer.setVolume(config.volume!);
    if (config.shuffled != null) {
      audioPlayer.setShuffled(config.shuffled!, shuffleQueue: false);
    }
    if (config.looped != null) audioPlayer.setLooped(config.looped!);
    if (config.queue != null) {
      await audioPlayer.setQueue(
        config.queue!
            .map((e) => libraryRepository.getTrackFromFile(File(e)))
            .toList(),
        index: config.index,
      );
    }
    if (config.position != null) {
      await audioPlayer.seek(Duration(seconds: config.position!));
    }
  }

  Future<void> dispose() => Future.wait([_pageController.close()]);
}

class ConfigStream {
  new({required this.page});

  final Stream<int> page;
}

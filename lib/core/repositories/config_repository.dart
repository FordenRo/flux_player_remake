import 'dart:async';
import 'dart:ui';

import 'package:window_manager/window_manager.dart';

import '../models/app_config.dart';
import '../services/audio_player.dart';

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
    page = config.page;
    await windowManager.setPosition(
      Offset(
        config.windowPosition.x.toDouble(),
        config.windowPosition.y.toDouble(),
      ),
    );
    await windowManager.setSize(
      Size(config.windowSize.x.toDouble(), config.windowSize.y.toDouble()),
    );
    // libraryRepository.setPaths(config.paths); or right in libraryRepository
    // but with configService.loadPaths

    // audioPlayer.setAudioDevice(device)
    await audioPlayer.setVolume(config.volume);
    audioPlayer
      ..setShuffled(config.shuffled, shuffleQueue: false)
      ..setLooped(config.looped);
  }

  Future<void> dispose() => Future.wait([_pageController.close()]);
}

class ConfigStream {
  new({required this.page});

  final Stream<int> page;
}

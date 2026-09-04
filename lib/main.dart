import 'dart:async';

import 'package:audio_service/audio_service.dart' show AudioService;
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'core/services/audio_handler.dart';
import 'core/services/audio_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await windowManager.ensureInitialized();

  await AudioService.init(
    builder: () => AudioHandler(player: audioPlayer),
    config: const .new(
      androidNotificationChannelId: 'com.cmpbronze.flux.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationChannelDescription: 'Flux Media Player',
      androidNotificationOngoing: true,
    ),
  );

  final session = await AudioSession.instance;
  await session.configure(const .music());

  runApp(const App());

  await windowManager.waitUntilReadyToShow(
    const .new(size: Size(720, 480), titleBarStyle: .hidden),
  );
}

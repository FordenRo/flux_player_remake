import 'package:flutter/material.dart';

import '../core/repositories/config_repository.dart';
import '../core/services/config_service.dart';
import '../core/theme/theme.dart';

import 'app_home.dart';
import 'widgets/loading_screen.dart';

enum AppPage { allTracks, playlists, netSearch, settings }

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flux Player',
    themeMode: .dark,
    theme: lightTheme,
    darkTheme: darkTheme,
    home: LoadingScreen(builder: (context) => const AppHome(), future: load()),
  );

  Future<void> load() async {
    final config = await configService.loadAppConfig();
    if (config != null) await configRepository.apply(config);
  }
}

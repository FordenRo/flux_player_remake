import 'dart:async';

import 'package:flutter/material.dart';

import '../core/repositories/config_repository.dart';
import '../core/services/audio_player.dart';
import '../core/theme/values.dart';
import '../ui/pages/all_tracks_page.dart';
import '../ui/pages/network_page.dart';
import '../ui/pages/playlists_page.dart';
import '../ui/pages/queue_page.dart';
import '../ui/pages/settings_page.dart';
import '../ui/player_controls/player_controls.dart';
import 'widgets/app_logo.dart';
import 'widgets/app_tab_button.dart';
import 'widgets/caption_widget.dart';

class AppHome extends StatefulWidget {
  const new({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late final StreamSubscription subscription;

  final pages = [
    const AllTracksPage(),
    const QueuePage(),
    const PlaylistsPage(),
    const NetworkPage(),
    const SettingsPage(),
  ];

  int get page => configRepository.page;
  set page(int value) => configRepository.page = value;

  @override
  void initState() {
    super.initState();
    subscription = configRepository.stream.page.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final sideBarChildren = [
      const AppLogo(),
      const SizedBox(height: 16),
      _buildTabButton('Все треки', Icons.search_rounded, 0),
      _buildTabButton('Очередь', Icons.music_note_rounded, 1),
      _buildTabButton('Плейлисты', Icons.library_music_rounded, 2),
      _buildTabButton('Скачать', Icons.download_rounded, 3),
      const Expanded(child: SizedBox()),
      _buildTabButton('Настройки', Icons.settings_rounded, 4),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Padding(
                  padding: const .symmetric(vertical: 16),
                  child: Column(children: sideBarChildren),
                ),
                Expanded(
                  child: Padding(
                    padding: const .only(right: 8, top: 8),
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: .stretch,
                      children: [
                        const CaptionWidget(),
                        Expanded(
                          child: Card(
                            margin: .zero,
                            clipBehavior: .antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: Radiuses.r12,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary
                                    .withAlpha(15),
                              ),
                            ),
                            color: Theme.of(context).colorScheme.primary
                                .withAlpha(12),
                            child: pages[page],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: audioPlayer.stream.currentIndex.map((e) => e != null),
            initialData: audioPlayer.currentIndex != null,
            builder: (context, asyncSnapshot) => asyncSnapshot.requireData
                ? const PlayerControls()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  AppTabButton _buildTabButton(String title, IconData icon, int page) =>
      AppTabButton(
        icon: icon,
        title: title,
        isSelected: this.page == page,
        onSelected: () => this.page = page,
      );
}

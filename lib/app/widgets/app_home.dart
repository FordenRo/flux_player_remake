import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/repositories/config_repository.dart';
import '../../core/services/audio_player.dart';
import '../../core/theme/values.dart';
import '../../ui/pages/all_tracks_page.dart';
import '../../ui/pages/network_page.dart';
import '../../ui/pages/queue_page.dart';
import '../../ui/pages/settings_page.dart';
import '../../ui/player_controls/player_controls.dart';
import 'caption_widget.dart';

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
    const SizedBox(),
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
      const _Logo(),
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

  _TabButton _buildTabButton(String title, IconData icon, int page) =>
      _TabButton(
        icon: icon,
        title: title,
        isSelected: this.page == page,
        onSelected: () => this.page = page,
      );
}

class _Logo extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(vertical: 8),
    child: StreamBuilder(
      stream: audioPlayer.stream.isPlaying,
      builder: (context, asyncSnapshot) => Image.asset(
        'assets/logo.png',
        width: 32,
        color: audioPlayer.isPlaying
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
    ),
  );
}

class _TabButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onSelected,
  });

  final IconData icon;
  final String title;
  final void Function() onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => TooltipTheme(
    data: .new(
      waitDuration: Durations.medium1,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: .all(.circular(8))),
      ),
      textStyle: .new(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    ),
    child: IconButton(
      tooltip: title,
      padding: const .symmetric(horizontal: 24, vertical: 10),
      onPressed: onSelected,
      isSelected: isSelected,
      style: .new(
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: .fromMap({
          WidgetState.hovered: !isSelected
              ? Theme.of(context).colorScheme.onSurface
              : null,
        }),
      ),
      icon: Icon(icon),
    ),
  );
}

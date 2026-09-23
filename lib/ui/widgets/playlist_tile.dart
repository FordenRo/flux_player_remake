import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../../core/models/playlist.dart';
import '../../core/repositories/playlist_repository.dart';
import '../../core/services/audio_player.dart';
import '../../core/theme/values.dart';
import 'fade_in_widget.dart';

class PlaylistTile extends StatefulWidget {
  const PlaylistTile(this.playlist, {super.key, this.onTap});

  final Playlist playlist;
  final void Function()? onTap;

  @override
  State<PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<PlaylistTile> {
  late final TextEditingController controller = .new(text: playlist.title);
  late final FocusNode focusNode = .new()..addListener(() => setState(() {}));

  Playlist get playlist => widget.playlist;
  Duration get overallDuration =>
      playlist.fold(Duration.zero, (prev, e) => prev + e.duration);

  var iconHovered = false;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlaylistTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.text = playlist.title;
  }

  Future<void> _showMenu(BuildContext context, TapDownDetails e) =>
      showContextMenu(
        context,
        contextMenu: .new(
          entries: [
            MenuItem(
              label: const Text('Переименовать'),
              onSelected: (_) => focusNode.requestFocus(),
            ),
            MenuItem(
              label: const Text('Удалить'),
              onSelected: (_) => playlistRepository.removePlaylist(playlist),
            ),
          ],
          position: e.globalPosition,
        ),
      );

  Expanded _buildInfo() => Expanded(
    child: Stack(
      children: [
        Center(
          child: TextField(
            selectAllOnFocus: true,
            ignorePointers: !focusNode.hasFocus,
            focusNode: focusNode,
            mouseCursor: const WidgetStateMouseCursor.fromMap({
              WidgetState.focused: SystemMouseCursors.text,
              WidgetState.any: .defer,
            }),
            onEditingComplete: () => playlist.title = controller.text,
            controller: controller,
            style: const .new(fontSize: 18),
            decoration: const .new(hintText: 'Название', border: .none),
          ),
        ),
        Align(
          alignment: .bottomLeft,
          child: Text(
            '${playlist.length} треков',
            style: .new(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            ),
          ),
        ),
        Align(
          alignment: .bottomRight,
          child: Text(
            overallDuration.inMinutes > 100
                ? '${(overallDuration.inMinutes / 60).toStringAsFixed(1)} часов'
                : '${overallDuration.inMinutes} минут',
            style: .new(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
            ),
          ),
        ),
        // if (configService.mainPlaylist == playlist)
        //   Align(
        //     alignment: .topRight,
        //     child: Icon(
        //       Icons.star_rounded,
        //       color: Theme.of(context).colorScheme.tertiary,
        //     ),
        //   ),
      ],
    ),
  );

  Container _buildIcon() => Container(
    width: 80,
    height: 80,
    clipBehavior: .hardEdge,
    decoration: BoxDecoration(
      borderRadius: Radiuses.r8,
      border: .all(strokeAlign: 1, width: 1, color: Colors.grey.shade600),
    ),
    child: Stack(
      fit: .expand,
      children: [
        GridView.count(
          primary: false,
          scrollDirection: .horizontal,
          crossAxisCount: 2,
          clipBehavior: .none,
          children: playlist
              .where((e) => e.picture != null)
              .take(4)
              .map(
                (e) => Image.memory(
                  e.picture!,
                  frameBuilder: (
                    context,
                    child,
                    frame,
                    wasSynchronouslyLoaded,
                  ) => FadeInWidget(duration: Durations.medium1, child: child),
                ),
              )
              .toList(),
        ),
        _PlayButton(playlist),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: .hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: Radiuses.r12,
      side: audioPlayer.currentPlaylist == playlist
          ? .new(color: Theme.of(context).colorScheme.primary)
          : .none,
    ),
    child: GestureDetector(
      onTap: !focusNode.hasFocus ? widget.onTap : null,
      behavior: .opaque,
      onSecondaryTapDown: (e) => _showMenu(context, e),
      child: Padding(
        padding: const .all(10),
        child: Row(spacing: 20, children: [_buildIcon(), _buildInfo()]),
      ),
    ),
  );
}

class _PlayButton extends StatefulWidget {
  const _PlayButton(this.playlist);

  final Playlist playlist;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController playAnim = .new(
    vsync: this,
    duration: Durations.short2,
    value: isVisible ? 1 : 0,
  );
  late final StreamSubscription isPlayingSub;
  late final StreamSubscription playlistSub;
  var isHovered = false;

  Playlist get playlist => widget.playlist;
  bool get isSelected => audioPlayer.currentPlaylist == playlist;
  bool get isPlaying => isSelected && audioPlayer.isPlaying;
  bool get isVisible => isHovered || isPlaying;

  @override
  void initState() {
    super.initState();
    isPlayingSub = audioPlayer.stream.isPlaying
        .where((_) => playlist == audioPlayer.currentPlaylist)
        .listen((_) => _update());
    playlistSub = audioPlayer.stream.currentPlaylist.listen((_) => _update());
  }

  @override
  void dispose() {
    isPlayingSub.cancel();
    playlistSub.cancel();
    super.dispose();
  }

  void _update() {
    setState(() {});
    playAnim.animateTo(isPlaying ? 1 : 0);
  }

  Future<void> _playPressed() async {
    if (isSelected) {
      isPlaying ? await audioPlayer.pause() : await audioPlayer.play();
    } else {
      await audioPlayer.setPlaylist(playlist, index: 0, play: true);
    }
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => isHovered = true),
    onExit: (_) => setState(() => isHovered = false),
    child: AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Durations.short2,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface.withAlpha(100),
        child: Center(
          child: IconButton(
            onPressed: _playPressed,
            iconSize: 32,
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playAnim,
            ),
          ),
        ),
      ),
    ),
  );
}

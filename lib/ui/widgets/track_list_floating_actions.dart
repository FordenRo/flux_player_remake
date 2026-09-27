import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/audio_player.dart';
import 'track_list_view.dart';

class TrackListFloatingActions extends StatefulWidget {
  const TrackListFloatingActions({
    required this.controller,
    required this.child,
    this.playingIndexCallback,
    this.showWatchTrack = true,
    this.showGoTop = true,
    super.key,
  });

  final Widget child;
  final TrackListController controller;
  final int? Function()? playingIndexCallback;
  final bool showWatchTrack;
  final bool showGoTop;

  @override
  State<TrackListFloatingActions> createState() =>
      _TrackListFloatingActionsState();
}

class _TrackListFloatingActionsState extends State<TrackListFloatingActions> {
  TrackListController get controller => widget.controller;

  late bool showWatchTrack = canShowWatchTrack();
  late bool showGoTop = canShowGoTop();
  var watchCurrentTrack = true;
  late final StreamSubscription subscription;

  bool canShowWatchTrack() =>
      widget.showWatchTrack &&
      audioPlayer.currentTrack != null &&
      widget.playingIndexCallback != null;
  bool canShowGoTop() =>
      widget.showGoTop && controller.hasClients && controller.offset > 500;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdate);
    subscription = audioPlayer.stream.currentIndex.listen(
      (_) => _onIndexUpdate(),
    );

    Future.microtask(_onIndexUpdate);
  }

  @override
  void didUpdateWidget(covariant TrackListFloatingActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    _onControllerUpdate();
    _onIndexUpdate();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void _onControllerUpdate() {
    final canShowWatch = canShowWatchTrack();
    final canShowTop = canShowGoTop();
    if (canShowWatch != showWatchTrack || canShowTop != showGoTop) {
      setState(() {
        showWatchTrack = canShowWatch;
        showGoTop = canShowTop;
      });
    }
    if (watchCurrentTrack && controller.position.userScrollDirection != .idle) {
      setState(() => watchCurrentTrack = false);
    }
  }

  void _onIndexUpdate() {
    if (showWatchTrack &&
        watchCurrentTrack &&
        widget.playingIndexCallback != null) {
      controller.animateToIndex(widget.playingIndexCallback!()!);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    alignment: .bottomEnd,
    children: [
      widget.child,
      Padding(
        padding: const .all(20),
        child: Column(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            AnimatedSlide(
              offset: Offset(0, showWatchTrack ? 0 : 1.4),
              duration: Durations.medium1,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: showGoTop ? 1 : 0,
                duration: Durations.medium1,
                child: IconButton.filled(
                  onPressed: () {
                    if (showGoTop) {
                      watchCurrentTrack = false;
                      controller.animateToTop();
                    }
                  },
                  iconSize: 20,
                  padding: .zero,
                  splashRadius: 10,
                  visualDensity: .compact,
                  style: .new(
                    backgroundColor: .all(
                      Color.alphaBlend(
                        Theme.of(context).colorScheme.secondary.withAlpha(100),
                        Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  color: Theme.of(context).colorScheme.onSurface,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: showWatchTrack ? 1 : 0,
              duration: Durations.medium1,
              child: IconButton.filled(
                onPressed: () {
                  if (showWatchTrack) {
                    setState(() => watchCurrentTrack = !watchCurrentTrack);
                    _onIndexUpdate();
                  } else if (showGoTop) {
                    controller.animateToTop();
                  }
                },
                iconSize: 22,
                padding: .zero,
                splashRadius: 10,
                visualDensity: .comfortable,
                style: .new(
                  backgroundColor: .all(
                    Color.alphaBlend(
                      Theme.of(context).colorScheme.primary.withAlpha(120),
                      Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  side: .all(
                    watchCurrentTrack
                        ? .new(
                            color: Color.alphaBlend(
                              Theme.of(context).colorScheme.onSurface
                                  .withAlpha(180),
                              Theme.of(context).colorScheme.surface,
                            ),
                            width: 2,
                          )
                        : .none,
                  ),
                ),
                color: Theme.of(context).colorScheme.onSurface,
                icon: const Icon(Icons.music_note_rounded),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

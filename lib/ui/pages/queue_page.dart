import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../core/services/audio_player.dart';
import '../../core/utils/move_element.dart';
import '../widgets/track_item.dart';
import '../widgets/track_list_view.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage>
    with AutomaticKeepAliveClientMixin<QueuePage> {
  late final StreamSubscription subscription;
  late final TrackListController controller = .new(
    onAttach: (position) => Future.microtask(animateToPlaying),
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    subscription = audioPlayer.stream.queue.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> animateToPlaying() async {
    if (audioPlayer.currentIndex != null) {
      await controller.animateToIndex(audioPlayer.currentIndex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tracks = audioPlayer.queue;

    return TrackListView(
      tracks: tracks,
      controller: controller,
      onTrackPlayed: (index) =>
          audioPlayer.setQueue(tracks, index: index, play: true),
      onTrackMoved: (oldIndex, newIndex) {
        audioPlayer.setQueue(
          tracks..move(oldIndex, newIndex),
          index: audioPlayer.currentIndex,
          load: false,
        );
        if (audioPlayer.currentIndex! == oldIndex) {
          audioPlayer.setIndex(newIndex, load: false);
        } else if (audioPlayer.currentIndex! < oldIndex &&
            audioPlayer.currentIndex! >= newIndex) {
          audioPlayer.setIndex(audioPlayer.currentIndex! + 1, load: false);
        } else if (audioPlayer.currentIndex! > oldIndex &&
            audioPlayer.currentIndex! <= newIndex) {
          audioPlayer.setIndex(audioPlayer.currentIndex! - 1, load: false);
        }
      },
      menuEntriesBuilder: (context, index) => [
        MenuItem(
          label: const Text('Убрать'),
          onSelected: (_) => audioPlayer.removeFromQueue(index),
        ),
      ],
      trackActionButtonsBuilder: (context, index, child) => [
        ...child,
        TrackActionButton(
          icon: Icons.close_rounded,
          iconSize: 20,
          onPressed: () => audioPlayer.removeFromQueue(index),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/audio_player.dart';
import '../search_field.dart';
import '../track/track_item.dart';
import '../track/track_list_view.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> {
  late final StreamSubscription subscription;

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

  @override
  Widget build(BuildContext context) {
    final tracks = audioPlayer.queue;

    return Column(
      children: [
        const SearchField(hint: 'Поиск треков'),
        Expanded(
          child: TrackListView(
            trackCount: tracks.length,
            trackBuilder: (context, idx) => StreamBuilder(
              stream: audioPlayer.stream.currentTrack,
              builder: (context, asyncSnapshot) => StreamBuilder(
                stream: audioPlayer.stream.isPlaying,
                builder: (context, asyncSnapshot) => TrackItem(
                  tracks[idx],
                  isSelected: audioPlayer.currentTrack == tracks[idx],
                  isPlaying:
                      audioPlayer.currentTrack == tracks[idx] &&
                      audioPlayer.isPlaying,
                  onPlayPressed: () =>
                      audioPlayer.setQueue(tracks, index: idx, play: true),
                  actionButtons: const [TrackNextAction()],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

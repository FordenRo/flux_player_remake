import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/audio_player.dart';
import '../widgets/track_list_view.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage>
    with AutomaticKeepAliveClientMixin<QueuePage> {
  late final StreamSubscription subscription;

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tracks = audioPlayer.queue;

    return TrackListView(
      tracks: tracks,
      onTrackPlayed: (index) =>
          audioPlayer.setQueue(tracks, index: index, play: true),
      trackActionButtons: const [
        // TrackActionButton(
        //   icon: Icons.close_rounded,
        //   iconSize: 20,
        //   onPressed: ,
        // ),
      ],
    );
  }
}

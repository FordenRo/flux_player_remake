import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import '../search_field.dart';
import '../track/track_item.dart';
import '../track/track_list_view.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = <Track>[];

    return Column(
      children: [
        const SearchField(),
        Expanded(
          child: TrackListView(
            trackCount: tracks.length,
            trackBuilder: (context, idx) => TrackItem(
              tracks[idx],
              onPlayPressed: () =>
                  audioPlayer.setQueue(tracks, index: idx, play: true),
            ),
          ),
        ),
      ],
    );
  }
}

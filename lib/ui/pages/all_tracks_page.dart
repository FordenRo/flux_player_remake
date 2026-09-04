import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/repositories/library_repository.dart';
import '../../core/services/audio_player.dart';
import '../search_field.dart';
import '../track/track_item.dart';
import '../track/track_list_view.dart';

class AllTracksPage extends StatelessWidget {
  const AllTracksPage({super.key});

  List<Track> get allTracks => libraryRepository.getAllTracks();
  List<Track> get sortedTracks =>
      allTracks.toList()..sort((a, b) => a.title.compareTo(b.title));

  @override
  Widget build(BuildContext context) {
    final tracks = sortedTracks;

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

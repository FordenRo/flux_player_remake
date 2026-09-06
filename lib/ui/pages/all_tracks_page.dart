import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/repositories/library_repository.dart';
import '../../core/services/audio_player.dart';
import '../../core/utils/track_search.dart';
import '../widgets/search_field.dart';
import '../widgets/track_item.dart';
import '../widgets/track_list_view_builder.dart';

class AllTracksPage extends StatefulWidget {
  const AllTracksPage({super.key});

  @override
  State<AllTracksPage> createState() => _AllTracksPageState();
}

class _AllTracksPageState extends State<AllTracksPage> {
  var query = '';

  List<Track> get allTracks => libraryRepository.getAllTracks();
  List<Track> get sortedTracks =>
      allTracks.toList()..sort((a, b) => a.title.compareTo(b.title));

  @override
  Widget build(BuildContext context) {
    final tracks = query.isNotEmpty
        ? searchTracks(allTracks, query)
        : sortedTracks;

    return Column(
      children: [
        SearchField(
          hint: 'Поиск треков',
          onChanged: (query) => setState(() => this.query = query),
        ),
        Expanded(
          child: TrackListViewBuilder(
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

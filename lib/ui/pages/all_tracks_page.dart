import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/repositories/library_repository.dart';
import '../../core/services/audio_player.dart';
import '../../core/utils/track_search.dart';
import '../widgets/search_field.dart';
import '../widgets/track_list_view.dart';

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
          child: TrackListView(
            tracks: tracks,
            onTrackPlayed: (index) =>
                audioPlayer.setQueue(tracks, index: index, play: true),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import '../../core/services/network_service.dart';
import '../widgets/search_field.dart';
import '../widgets/track_list_view.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  var query = '';

  Future<void> download(Track track) async {
    await networkService.downloadTrack(track);
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SearchField(
        hint: 'Искать треки',
        onSubmitted: (value) => setState(() => query = value),
      ),

      FutureBuilder(
        future: networkService.queryTracks(query),
        builder: (context, asyncSnapshot) => asyncSnapshot.hasData
            ? Expanded(
                child: TrackListView(
                  tracks: asyncSnapshot.requireData,
                  onTrackPlayed: (index) => audioPlayer.setQueue(
                    asyncSnapshot.requireData,
                    index: index,
                    play: true,
                  ),
                ),
              )
            : asyncSnapshot.hasError
            ? Text(asyncSnapshot.error.toString())
            : const Text('Loading'),
      ),
    ],
  );
}

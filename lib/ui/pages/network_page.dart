import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import '../../core/services/network_service.dart';
import '../search_field.dart';
import '../track/track_item.dart';
import '../track/track_list_view_builder.dart';

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
                child: TrackListViewBuilder(
                  trackCount: asyncSnapshot.requireData.length,
                  trackBuilder: (context, idx) => TrackItem(
                    asyncSnapshot.requireData[idx],
                    actionButtons: const [
                      // TrackActionButton(
                      //   icon: Icons.download_rounded,
                      //   iconSize: 16,
                      //   onPressed: () =>
                      //       download(asyncSnapshot.requireData[idx]),
                      // ),
                      TrackDownloadAction(),
                      TrackNextAction(),
                    ],
                    onPlayPressed: () => audioPlayer.setQueue(
                      asyncSnapshot.requireData,
                      index: idx,
                      play: true,
                    ),
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

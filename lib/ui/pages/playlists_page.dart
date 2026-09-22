import 'package:flutter/material.dart';

import '../../core/models/playlist.dart';
import '../../core/repositories/playlist_repository.dart';
import '../../core/services/audio_player.dart';
import '../widgets/playlist_tile.dart';
import '../widgets/track_list_view.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  Playlist? openedPlaylist;

  ReorderableListView _buildPlaylistList(List<Playlist> playlists) => .builder(
    itemCount: playlists.length,
    itemExtent: 110,
    buildDefaultDragHandles: false,
    onReorderItem: (oldIndex, newIndex) {}, // TODO
    itemBuilder: (context, idx) => ReorderableDragStartListener(
      key: Key(idx.toString()),
      index: idx,
      child: _playlistBuilder(playlists[idx]),
    ),
  );

  Widget _playlistBuilder(Playlist playlist) => PlaylistTile(
    playlist,
    onTap: () => setState(() => openedPlaylist = playlist),
  );

  @override
  Widget build(BuildContext context) => openedPlaylist == null
      ? ListenableBuilder(
          listenable: playlistRepository,
          builder: (context, value) => Scaffold(
            floatingActionButton: FloatingActionButton.small(
              onPressed: playlistRepository.createPlaylist,
              shape: const CircleBorder(),
              backgroundColor: .alphaBlend(
                Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
                Theme.of(context).colorScheme.surface,
              ),
              child: const Icon(Icons.add),
            ),
            body: _buildPlaylistList(playlistRepository.getAllPlaylists()),
          ),
        )
      : ListenableBuilder(
          listenable: openedPlaylist!,
          builder: (context, child) => TrackListView(
            tracks: openedPlaylist!.toList(),
            onTrackPlayed: (idx) => audioPlayer.setPlaylist(
              openedPlaylist!,
              index: idx,
              play: true,
            ),
          ),
        );
}

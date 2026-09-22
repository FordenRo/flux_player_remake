import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../core/models/playlist.dart';
import '../../core/models/track.dart';
import '../../core/repositories/library_repository.dart';
import '../../core/repositories/playlist_repository.dart';
import '../../core/services/audio_player.dart';
import '../../core/utils/global_paint_bounds.dart';
import '../../core/utils/track_search.dart';
import '../widgets/search_field.dart';
import '../widgets/track_list_view.dart';

enum _Sorting { title, artist, date }

class AllTracksPage extends StatefulWidget {
  const AllTracksPage({super.key});

  @override
  State<AllTracksPage> createState() => _AllTracksPageState();
}

class _AllTracksPageState extends State<AllTracksPage> {
  var query = '';
  _Sorting sorting = .title;

  List<Track> get allTracks => libraryRepository.getAllTracks();
  List<Track> get sortedTracks => allTracks.toList()..sort(_sort);
  List<Playlist> get playlists => playlistRepository.getAllPlaylists();

  String sortingToText(_Sorting sorting) => switch (sorting) {
    .title => 'Название',
    .artist => 'Исполнитель',
    .date => 'Дата добавл.',
  };

  int _sort(Track a, Track b) => switch (sorting) {
    .title => a.title.compareTo(b.title),
    .artist => a.artist.compareTo(b.artist),
    .date => throw UnimplementedError(),
  };

  @override
  Widget build(BuildContext context) {
    final tracks = query.isNotEmpty
        ? searchTracks(allTracks, query)
        : sortedTracks;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchField(
                hint: 'Поиск треков',
                onChanged: (query) => setState(() => this.query = query),
              ),
            ),
            AnimatedSize(
              duration: Durations.short3,
              child: query.isEmpty
                  ? Builder(
                      builder: (context) => TextButton.icon(
                        onPressed: () async {
                          final sort = await showContextMenu(
                            context,
                            contextMenu: ContextMenu<_Sorting>(
                              entries: [
                                MenuItem(
                                  label: Text(sortingToText(.title)),
                                  value: .title,
                                ),
                                MenuItem(
                                  label: Text(sortingToText(.artist)),
                                  value: .artist,
                                ),
                                MenuItem(
                                  label: Text(sortingToText(.date)),
                                  value: .date,
                                ),
                              ],
                              position: context
                                  .findRenderObject()!
                                  .globalPaintBounds
                                  .bottomCenter,
                            ),
                          );
                          setState(() => sorting = sort ?? sorting);
                        },
                        label: Text(sortingToText(sorting)),
                        icon: const Icon(Icons.sort_rounded),
                        style: .new(
                          foregroundColor: .all(
                            Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(width: 0),
            ),
          ],
        ),
        Expanded(
          child: TrackListView(
            tracks: tracks,
            menuEntriesBuilder: (context, index) => [
              MenuItem(
                label: const Text('Играть следующим'),
                onSelected: (_) => audioPlayer.addNext(tracks[index]),
              ),
              if (playlists.isNotEmpty &&
                  playlists.any((e) => !e.contains(tracks[index])))
                MenuItem.submenu(
                  label: const Text('Добавить в плейлист'),
                  items: playlists
                      .where((e) => !e.contains(tracks[index]))
                      .map(
                        (e) => MenuItem<void>(
                          label: Text(e.title),
                          onSelected: (_) => e.add(tracks[index]),
                        ),
                      )
                      .toList(),
                ),
              if (playlists.isNotEmpty &&
                  playlists.any((e) => e.contains(tracks[index])))
                MenuItem.submenu(
                  label: const Text('Удалить из плейлиста'),
                  items: playlists
                      .where((e) => e.contains(tracks[index]))
                      .map(
                        (e) => MenuItem<void>(
                          label: Text(e.title),
                          onSelected: (_) => e.remove(tracks[index]),
                        ),
                      )
                      .toList(),
                ),
              const MenuItem(label: Text('Удалить')), // TODO
            ],
            onTrackPlayed: (index) =>
                audioPlayer.setQueue(tracks.toList(), index: index, play: true),
          ),
        ),
      ],
    );
  }
}

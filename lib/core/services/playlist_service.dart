import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/playlist.dart';
import '../repositories/library_repository.dart';

final playlistService = PlaylistService._();

class PlaylistService {
  PlaylistService._();

  Future<void> savePlaylists(List<Playlist> playlists) async {
    final dir = '${(await getApplicationSupportDirectory()).path}/playlists';

    for (final e in playlists) {
      File('$dir/${e.title}')
        ..createSync(recursive: true)
        ..writeAsStringSync(
          e.map((e) => '${e.title} - ${e.artist}').join('\n'),
        );
    }
  }

  Future<List<Playlist>> loadPlaylists() async {
    final dir = Directory(
      '${(await getApplicationSupportDirectory()).path}/playlists',
    );
    if (!dir.existsSync()) return [];

    return dir
        .listSync()
        .whereType<File>()
        .map(
          (e) async => Playlist(
            title: e.uri.pathSegments.last.split('.').first,
            tracks: (await e.readAsLines())
                .map((l) => libraryRepository.getTrackFromFile(File(l)))
                .toList(),
          ),
        )
        .wait;
  }
}

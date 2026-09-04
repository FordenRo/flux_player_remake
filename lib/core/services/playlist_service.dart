import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/playlist.dart';

class PlaylistService {
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

  // Future<List<Playlist>> loadPlaylists() async {
  //   final dir = Directory(
  //     '${(await getApplicationSupportDirectory()).path}/playlists',
  //   );
  //   if (!dir.existsSync()) return [];

  //   playlists = dir.listSync().whereType<File>()
  // }
}

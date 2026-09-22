import 'package:flutter/material.dart';

import '../models/playlist.dart';
import '../services/playlist_service.dart';

final playlistRepository = PlaylistRepository._();

class PlaylistRepository with ChangeNotifier {
  PlaylistRepository._();

  List<Playlist> _playlists = [];

  Future<void> loadPlaylists() async {
    _playlists = await playlistService.loadPlaylists();
  }

  List<Playlist> getAllPlaylists() => _playlists.toList();

  Playlist createPlaylist() {
    final playlist = Playlist(title: 'Новый плейлист');
    _playlists.add(playlist);
    notifyListeners();
    return playlist;
  }
}

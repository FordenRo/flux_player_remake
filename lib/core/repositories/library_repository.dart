import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart'
    show readMetadata;

import '../models/track.dart';

const audioExtensions = ['mp3', 'ogg', 'aac', 'flac', 'midi', 'wav', 'v4a'];

final libraryRepository = LibraryRepository._();

class LibraryRepository {
  LibraryRepository._();

  List<Track>? _cachedTracks;
  List<Track>? _allTracks;
  var _paths = <String>{'C:/Users/FordenRo/Music'};

  List<Track> getAllTracks() => _allTracks ??= _paths
      .map(
        (e) =>
            Directory(e)
                .listSync()
                .whereType<File>()
                .where((e) => audioExtensions.contains(e.path.split('.').last))
                .map(getTrackFromFile),
      )
      .fold(<Track>[], (a, b) => a.followedBy(b).toList())
      .toList();

  List<String> getPaths() => _paths.toList();

  Track getTrackFromFile(File file) =>
      _cachedTracks?.firstWhere(
        (e) => e.path == file.path,
        orElse: () => _loadTrack(file),
      ) ??
      _loadTrack(file);

  void setPaths(Iterable<String> paths) => _paths = paths.toSet();

  void addPath(String path) {
    _paths.add(path);
    _allTracks = null;
  }

  void removePath(String path) {
    _paths.remove(path);
    _allTracks = null;
  }
}

Track _loadTrack(File file) {
  final metadata = readMetadata(file);
  return .new(
    title: metadata.title!,
    artist: metadata.artist!,
    path: file.path,
    duration: metadata.duration!,
    album: metadata.album,
  );
}

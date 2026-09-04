import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart'
    show readMetadata;

import '../models/track.dart';

const audioExtensions = ['mp3', 'ogg', 'aac', 'flac', 'midi', 'wav', 'v4a'];

final libraryRepository = LibraryRepository._();

class LibraryRepository {
  LibraryRepository._();

  List<Track>? _tracks;
  var _paths = <String>{'C:/Users/FordenRo/Music'};

  List<Track> getAllTracks() => _tracks ??= _paths
      .map(
        (e) =>
            Directory(e)
                .listSync()
                .whereType<File>()
                .where((e) => audioExtensions.contains(e.path.split('.').last))
                .map(loadTrackFromFile),
      )
      .fold(<Track>[], (a, b) => a.followedBy(b).toList())
      .toList();

  List<String> getPaths() => _paths.toList();

  void setPaths(Iterable<String> paths) => _paths = paths.toSet();

  void addPath(String path) {
    _paths.add(path);
    _tracks = null;
  }

  void removePath(String path) {
    _paths.remove(path);
    _tracks = null;
  }
}

Track loadTrackFromFile(File file) {
  final metadata = readMetadata(file);
  return .new(
    title: metadata.title!,
    artist: metadata.artist!,
    path: file.path,
    duration: metadata.duration!,
    album: metadata.album,
  );
}

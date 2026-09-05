import 'dart:typed_data';

class Track {
  const new({
    required this.path,
    required this.title,
    required this.artist,
    required this.duration,
    this.album,
    this.picture,
    this.isLocal = true,
  });

  final String path;
  final String title;
  final String artist;
  final String? album;
  final Duration duration;
  final Uint8List? picture;
  final bool isLocal;

  bool get isRemote => !isLocal;
}

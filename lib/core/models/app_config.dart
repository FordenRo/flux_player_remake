class AppConfig {
  new({
    required this.page,
    required this.volume,
    required this.position,
    required this.device,
    required this.looped,
    required this.shuffled,
    required this.windowPosition,
    required this.windowSize,
    required this.libraryPaths,
    required this.downloadPath,
    required this.queue,
    required this.index,
    required this.playlist,
  });

  AppConfig.fromJson(Map<String, dynamic> map)
    : page = (map['page'] as num?)?.toInt(),
      volume = (map['volume'] as num?)?.toDouble(),
      position = (map['position'] as num?)?.toInt(),
      device = map['device'] as String?,
      looped = map['looped'] as bool?,
      shuffled = map['shuffled'] as bool?,
      libraryPaths = (map['libraryPaths'] as List<dynamic>?)?.cast<String>(),
      downloadPath = map['downloadPath'] as String?,
      queue = (map['queue'] as List<dynamic>?)?.cast<String>(),
      index = (map['index'] as num?)?.toInt(),
      playlist = map['playlist'] as String?,
      windowPosition = map['windowPosition'] != null
          ? Point.fromJson((map['windowPosition'] as List<dynamic>).cast<int>())
          : null,
      windowSize = map['windowSize'] != null
          ? Point.fromJson((map['windowSize'] as List<dynamic>).cast<int>())
          : null;

  final int? page;
  final double? volume;
  final int? position;
  final Point? windowSize;
  final Point? windowPosition;
  final String? device;
  final bool? looped;
  final bool? shuffled;
  final List<String>? libraryPaths;
  final String? downloadPath;
  final List<String>? queue;
  final int? index;
  final String? playlist;

  Map<String, dynamic> toJson() => {
    'page': page,
    'volume': volume,
    'position': position,
    'device': device,
    'looped': looped,
    'shuffled': shuffled,
    'libraryPaths': libraryPaths,
    'downloadPath': downloadPath,
    'windowPosition': windowPosition,
    'windowSize': windowSize,
    'queue': queue,
    'index': index,
    'playlist': playlist,
  };
}

class Point {
  new(this.x, this.y);

  factory Point.fromJson(List<int> json) => Point(json[0], json[1]);

  final int x;
  final int y;

  List<int> toJson() => [x, y];
}

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
  });

  AppConfig.fromMap(Map<String, dynamic> map)
    : page = (map['page'] as num?)?.toInt(),
      volume = (map['volume'] as num?)?.toDouble(),
      position = (map['position'] as num?)?.toInt(),
      device = map['device'] as String?,
      looped = map['looped'] as bool?,
      shuffled = map['shuffled'] as bool?,
      libraryPaths = map['libraryPaths'] as List<String>?,
      downloadPath = map['downloadPath'] as String?,
      queue = map['queue'] as List<String>?,
      index = (map['index'] as num?)?.toInt(),
      windowPosition = map['windowPosition'] as ({int x, int y})?,
      windowSize = map['windowSize'] as ({int x, int y})?;

  final int? page;
  final double? volume;
  final int? position;
  final ({int x, int y})? windowSize;
  final ({int x, int y})? windowPosition;
  final String? device;
  final bool? looped;
  final bool? shuffled;
  final List<String>? libraryPaths;
  final String? downloadPath;
  final List<String>? queue;
  final int? index;

  Map<String, dynamic> toMap() => {
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
  };
}

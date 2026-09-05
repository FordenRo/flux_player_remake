class AppConfig {
  new({
    this.page,
    this.volume,
    this.position,
    this.device,
    this.looped,
    this.shuffled,
    this.windowPosition,
    this.windowSize,
    this.libraryPaths,
    this.queue,
    this.index,
  });

  AppConfig.fromMap(Map<String, dynamic> map)
    : page = (map['page'] as num?)?.toInt(),
      volume = (map['volume'] as num?)?.toDouble(),
      position = (map['position'] as num?)?.toInt(),
      device = map['device'] as String?,
      looped = map['looped'] as bool?,
      shuffled = map['shuffled'] as bool?,
      libraryPaths = map['libraryPaths'] as List<String>?,
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
    'windowPosition': windowPosition,
    'windowSize': windowSize,
    'queue': queue,
    'index': index,
  };
}

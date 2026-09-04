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
  });

  AppConfig.fromMap(Map<String, dynamic> map)
    : page = (map['page'] as num).toInt(),
      volume = (map['volume'] as num).toDouble(),
      position = (map['position'] as num).toDouble(),
      device = map['device'] as String,
      looped = map['looped'] as bool,
      shuffled = map['shuffled'] as bool,
      windowPosition = map['windowPosition'] as ({int x, int y}),
      windowSize = map['windowSize'] as ({int x, int y});

  int page;
  double volume;
  double position;
  ({int x, int y}) windowSize;
  ({int x, int y}) windowPosition;
  String device;
  bool looped;
  bool shuffled;

  Map<String, dynamic> toMap() => {
    'page': page,
    'volume': volume,
    'position': position,
    'device': device,
    'looped': looped,
    'shuffled': shuffled,
    'windowPosition': windowPosition,
    'windowSize': windowSize,
  };
}

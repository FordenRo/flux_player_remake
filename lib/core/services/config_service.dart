import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/app_config.dart';

final configService = ConfigService();

class ConfigService {
  Future<void> saveAppConfig(AppConfig config) async =>
      File('${(await getApplicationSupportDirectory()).path}/config2')
        ..createSync(recursive: true)
        ..writeAsStringSync(jsonEncode(config));

  Future<AppConfig?> loadAppConfig() async {
    final file = File(
      '${(await getApplicationSupportDirectory()).path}/config2',
    );
    if (!file.existsSync()) return null;

    return AppConfig.fromMap(
      jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
    );
  }
}

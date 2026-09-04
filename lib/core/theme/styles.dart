// ignore_for_file: avoid_classes_with_only_static_members
import 'package:flutter/material.dart';

import 'theme.dart';

abstract final class TextStyles {
  static final TextStyle trackTitle = .new(
    fontSize: 13,
    color: appTheme.colorScheme.onSurface,
  );

  static final TextStyle trackArtist = .new(
    fontSize: 13,
    color: appTheme.colorScheme.onSurface.withAlpha(170),
  );

  static final TextStyle trackDuration = .new(
    fontSize: 13,
    color: appTheme.colorScheme.onSurfaceVariant,
  );
}

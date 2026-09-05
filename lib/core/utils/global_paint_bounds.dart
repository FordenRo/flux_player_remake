import 'package:flutter/material.dart';

extension GlobalPaintBounds on RenderObject {
  Rect get globalPaintBounds {
    final translation = getTransformTo(null).getTranslation();
    return paintBounds.shift(Offset(translation.x, translation.y));
  }
}

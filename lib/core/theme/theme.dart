import 'package:flutter/material.dart';

ThemeData get lightTheme =>
    .new(colorScheme: .fromSeed(seedColor: Colors.blue));

ThemeData get darkTheme => .new(
  colorScheme: .fromSeed(seedColor: Colors.blue, brightness: .dark),
);

ThemeData get appTheme => darkTheme;

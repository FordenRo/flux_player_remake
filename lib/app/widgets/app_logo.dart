import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/audio_player.dart';

class AppLogo extends StatefulWidget {
  const new({super.key});

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late final StreamSubscription subscription;
  late final animation = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );

  @override
  void initState() {
    super.initState();
    subscription = audioPlayer.stream.isPlaying.listen(
      (value) => animation.animateTo(value ? 0 : 1),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(vertical: 8),
    child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Image.asset(
        'assets/logo.png',
        width: 32,
        color: .lerp(
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.onSurface,
          animation.value,
        ),
      ),
    ),
  );
}

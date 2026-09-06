import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/services/audio_player.dart';

class VolumeButton extends StatefulWidget {
  const new({super.key});

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription subscription;
  late final controller = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );
  late final colorAnim = ColorTween(
    begin: Theme.of(context).colorScheme.primary.withAlpha(100),
    end: Theme.of(context).colorScheme.primary.withAlpha(200),
  ).animate(controller);
  Timer? animTimer;

  var lastVolume = audioPlayer.volume;

  @override
  void initState() {
    super.initState();
    subscription = audioPlayer.stream.volume.listen(
      (_) => setState(updateAnim),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    animTimer?.cancel();
  }

  void mute() {
    if (audioPlayer.volume > 0) {
      lastVolume = audioPlayer.volume;
      audioPlayer.setVolume(0);
    } else {
      audioPlayer.setVolume(lastVolume);
    }
  }

  void updateAnim() {
    if (!(animTimer?.isActive ?? false)) controller.animateTo(1);
    animTimer?.cancel();
    animTimer = Timer(
      const Duration(seconds: 1),
      () => controller.animateBack(0),
    );
  }

  IconData _getIconDataFromVolume(double volume) => switch (volume) {
    > .7 => Icons.volume_up_rounded,
    > .3 => Icons.volume_down_rounded,
    > 0 => Icons.volume_mute_rounded,
    _ => Icons.volume_off_rounded,
  };

  @override
  Widget build(BuildContext context) => Listener(
    onPointerSignal: (e) {
      if (e is PointerScrollEvent) {
        audioPlayer.setVolume(audioPlayer.volume - e.scrollDelta.dy / 5000);
      }
    },
    child: Stack(
      alignment: .center,
      children: [
        SizedBox.square(
          dimension: 40,
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) => CircularProgressIndicator(
              value: audioPlayer.volume,
              valueColor: colorAnim,
              strokeAlign: -1,
              strokeWidth: 2.5,
              strokeCap: .round,
            ),
          ),
        ),
        IconButton(
          onPressed: mute,
          icon: Icon(_getIconDataFromVolume(audioPlayer.volume)),
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    ),
  );
}

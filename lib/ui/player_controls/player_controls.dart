import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../core/services/audio_player.dart';
import '../../core/theme/styles.dart';
import '../../core/theme/values.dart';
import '../../core/utils/global_paint_bounds.dart';
import '../widgets/track_icon.dart';
import 'widgets/position_slider.dart';
import 'widgets/volume_button.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls({super.key});

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls>
    with SingleTickerProviderStateMixin {
  late final StreamSubscription subscription;
  late final AnimationController playAnim = .new(
    vsync: this,
    duration: Durations.short2,
  );

  @override
  void initState() {
    super.initState();
    subscription = audioPlayer.stream.isPlaying.listen((_) {
      playAnim.animateTo(audioPlayer.isPlaying ? 1 : 0);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    playAnim.dispose();
    subscription.cancel();
  }

  Future<void> showDeviceContextMenu(BuildContext context) async {
    final menu = ContextMenu(
      position: context.findRenderObject()!.globalPaintBounds.center,
      padding: .zero,
      entries: audioPlayer.audioDevices
          .map(
            (e) => MenuItem(
              label: Text(e.description, style: const .new(fontSize: 12)),
              value: e,
              enabled: audioPlayer.audioDevice != e,
            ),
          )
          .toList(),
    );
    final device = await menu.show(context);
    if (device != null) await audioPlayer.setAudioDevice(device);
  }

  @override
  Widget build(BuildContext context) {
    final trackInfo = StreamBuilder(
      stream: audioPlayer.stream.currentTrack,
      builder: (context, asyncSnapshot) => Row(
        spacing: 8,
        children: [
          const TrackIcon(size: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  audioPlayer.currentTrack!.title,
                  overflow: .ellipsis,
                  style: TextStyles.trackTitle,
                ),
                Text(
                  audioPlayer.currentTrack!.artist,
                  overflow: .ellipsis,
                  style: TextStyles.trackArtist,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final controlButtons = [
      /// Shuffle
      StreamBuilder(
        stream: audioPlayer.stream.isShuffled,
        builder: (context, asyncSnapshot) => IconButton(
          color: audioPlayer.isShuffled
              ? Theme.of(context).colorScheme.primary
              : null,
          onPressed: () => audioPlayer.setShuffled(!audioPlayer.isShuffled),
          icon: const Icon(Icons.shuffle_rounded),
        ),
      ),

      /// Previous
      _SlideOnPressIconButton(
        icon: const Icon(Icons.skip_previous_rounded),
        onPressed: audioPlayer.previous,
        offset: -0.1,
      ),

      /// Play/Pause
      StreamBuilder(
        stream: audioPlayer.stream.isPlaying,
        builder: (context, asyncSnapshot) => IconButton(
          onPressed: () =>
              audioPlayer.isPlaying ? audioPlayer.pause() : audioPlayer.play(),
          icon: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: playAnim,
          ),
        ),
      ),

      /// Next
      _SlideOnPressIconButton(
        icon: const Icon(Icons.skip_next_rounded),
        onPressed: audioPlayer.next,
        offset: 0.1,
      ),

      /// Loop
      StreamBuilder(
        stream: audioPlayer.stream.isLooped,
        builder: (context, asyncSnapshot) => AnimatedRotation(
          duration: Durations.short3,
          turns: audioPlayer.isLooped ? -0.5 : 0,
          child: IconButton(
            color: audioPlayer.isLooped
                ? Theme.of(context).colorScheme.primary
                : null,
            onPressed: () => audioPlayer.setLooped(!audioPlayer.isLooped),
            icon: const Icon(Icons.loop_rounded),
          ),
        ),
      ),
    ];

    final sideButtons = [
      Builder(
        builder: (context) => IconButton(
          onPressed: () => showDeviceContextMenu(context),
          icon: const Icon(Icons.input_rounded),
        ),
      ),
      const VolumeButton(),
    ];

    return Card(
      clipBehavior: .hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: Radiuses.r12,
        side: BorderSide(
          color: audioPlayer.isPlaying
              ? Theme.of(context).colorScheme.primary.withAlpha(200)
              : Theme.of(context).colorScheme.secondary.withAlpha(200),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const .only(top: 8, right: 8, left: 8, bottom: 4),
            child: Row(
              children: [
                Expanded(child: trackInfo),
                Row(mainAxisAlignment: .center, children: controlButtons),
                Expanded(
                  child: Row(mainAxisAlignment: .end, children: sideButtons),
                ),
              ],
            ),
          ),
          const PositionSlider(),
        ],
      ),
    );
  }
}

class _SlideOnPressIconButton extends StatefulWidget {
  const new({
    required this.icon,
    required this.onPressed,
    required this.offset,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final double offset;

  @override
  State<_SlideOnPressIconButton> createState() =>
      _SlideOnPressIconButtonState();
}

class _SlideOnPressIconButtonState extends State<_SlideOnPressIconButton> {
  double offset = 0;

  @override
  Widget build(BuildContext context) => AnimatedSlide(
    offset: Offset(offset * widget.offset, 0),
    duration: Durations.short2,
    onEnd: () => setState(() => offset = 0),
    child: IconButton(
      onPressed: () {
        setState(() => offset = 1);
        widget.onPressed?.call();
      },
      icon: widget.icon,
    ),
  );
}

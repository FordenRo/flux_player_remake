import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/theme/values.dart';
import 'fade_in_widget.dart';
import 'play_button.dart';

class TrackIcon extends StatelessWidget {
  const TrackIcon({
    this.playButton,
    this.size,
    this.iconSize,
    this.picture,
    super.key,
  });

  final double? size;
  final PlayButton? playButton;
  final double? iconSize;
  final Uint8List? picture;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    clipBehavior: .hardEdge,
    decoration: BoxDecoration(
      borderRadius: Radiuses.r8,
      border: .all(
        strokeAlign: 1,
        width: 1,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
      ),
    ),
    child: Stack(
      alignment: .center,
      children: [
        if (picture != null)
          Image.memory(
            picture!,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                FadeInWidget(duration: Durations.medium1, child: child),
          )
        else
          Icon(
            Icons.music_note_rounded,
            size: iconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ?playButton,
      ],
    ),
  );
}

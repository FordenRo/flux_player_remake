import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import '../../core/theme/styles.dart';
import '../../core/theme/values.dart';
import 'play_button.dart';
import 'track_icon.dart';

class TrackItem extends StatelessWidget {
  const TrackItem(
    this.track, {
    this.onPlayPressed,
    this.actionButtons,
    this.isPlaying = false,
    this.isSelected = false,
    super.key,
  });

  final Track track;
  final List<Widget>? actionButtons;
  final VoidCallback? onPlayPressed;
  final bool isPlaying;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final children = [
      _buildIcon(),
      _buildText(),
      if (actionButtons != null)
        Provider.value(
          value: track,
          child: Row(children: actionButtons!),
        ),
      _buildDuration(),
    ];

    return GestureDetector(
      child: Card(
        clipBehavior: .hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: Radiuses.r12,
          side: isSelected
              ? BorderSide(color: Theme.of(context).colorScheme.primary)
              : .none,
        ),
        child: Padding(
          padding: const .symmetric(horizontal: 8),
          child: Row(spacing: 8, children: children),
        ),
      ),
    );
  }

  Text _buildDuration() => Text(
    '${track.duration.inMinutes.toString().padLeft(2, '0')}'
    ':'
    '${(track.duration.inSeconds % 60).toString().padLeft(2, '0')}',
    style: TextStyles.trackDuration,
  );

  Expanded _buildText() => Expanded(
    child: RichText(
      overflow: .ellipsis,
      text: TextSpan(
        text: '${track.title}  ',
        style: TextStyles.trackTitle,
        children: [TextSpan(text: track.artist, style: TextStyles.trackArtist)],
      ),
    ),
  );

  Widget _buildIcon() => TrackIcon(
    size: 30,
    iconSize: 20,
    playButton: onPlayPressed != null
        ? PlayButton(
            onPressed: onPlayPressed!,
            isPlaying: isPlaying,
            iconSize: 20,
          )
        : null,
  );
}

class TrackActionButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.onPressed,
    this.iconSize,
    super.key,
  });

  final IconData icon;
  final void Function() onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    icon: Icon(icon, size: iconSize),
    color: Theme.of(context).colorScheme.onSurfaceVariant,
    style: .new(minimumSize: .all(.zero), padding: .all(const .all(4))),
  );
}

class TrackNextAction extends StatelessWidget {
  const new({this.iconSize, super.key});

  final double? iconSize;

  @override
  Widget build(BuildContext context) => TrackActionButton(
    icon: Icons.navigate_next_rounded,
    iconSize: iconSize,
    onPressed: () =>
        audioPlayer.addNext(Provider.of<Track>(context, listen: false)),
  );
}

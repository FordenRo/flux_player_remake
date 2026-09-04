import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  const new({
    required this.onPressed,
    required this.isPlaying,
    required this.iconSize,
    super.key,
  });

  final void Function() onPressed;
  final double? iconSize;
  final bool isPlaying;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late final anim = AnimationController(
    vsync: this,
    duration: Durations.short2,
    value: isVisible ? 1 : 0,
  );

  var isHovered = false;
  bool get isVisible => isHovered || widget.isPlaying;

  @override
  void didUpdateWidget(covariant PlayButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    anim.animateTo(widget.isPlaying ? 1 : 0);
  }

  @override
  void dispose() {
    super.dispose();
    anim.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => isHovered = true),
    onExit: (_) => setState(() => isHovered = false),
    child: GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Durations.short2,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface.withAlpha(100),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              size: widget.iconSize,
              color: Theme.of(context).colorScheme.onSurface,
              progress: anim,
            ),
          ),
        ),
      ),
    ),
  );
}

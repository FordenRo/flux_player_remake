import 'package:flutter/material.dart';

class AppTabButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onSelected,
    super.key,
  });

  final IconData icon;
  final String title;
  final void Function() onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => TooltipTheme(
    data: .new(
      waitDuration: Durations.medium1,
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: const RoundedRectangleBorder(borderRadius: .all(.circular(8))),
      ),
      textStyle: .new(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    ),
    child: IconButton(
      tooltip: title,
      padding: const .symmetric(horizontal: 24, vertical: 10),
      onPressed: onSelected,
      isSelected: isSelected,
      style: .new(
        splashFactory: NoSplash.splashFactory,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: .fromMap({
          WidgetState.hovered: !isSelected
              ? Theme.of(context).colorScheme.onSurface
              : null,
        }),
      ),
      icon: Icon(icon),
    ),
  );
}

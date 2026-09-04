import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/theme/values.dart';

class CaptionWidget extends StatefulWidget {
  const CaptionWidget({super.key});

  @override
  State<CaptionWidget> createState() => _CaptionWidgetState();
}

class _CaptionWidgetState extends State<CaptionWidget> {
  @override
  Widget build(BuildContext context) => IconButtonTheme(
    data: .new(
      style: .new(
        padding: .all(.zero),
        shape: .all(const RoundedRectangleBorder(borderRadius: Radiuses.r6)),
      ),
    ),
    child: SizedBox(
      height: 28,
      child: Padding(
        padding: const .symmetric(horizontal: 10, vertical: 2),
        child: Row(
          children: [
            // AnimatedSize(
            //   duration: Durations.medium1,
            //   curve: Curves.easeOutCubic,
            //   child: Row(
            //     children: captionWidgets.map((e) => e(context)).toList(),
            //   ),
            // ),
            Expanded(
              child: GestureDetector(
                onPanStart: (details) => windowManager.startDragging(),
              ),
            ),
            IconButton(
              onPressed: windowManager.minimize,
              icon: const Icon(Icons.minimize_rounded),
            ),
            IconButton(
              hoverColor: Colors.red.shade600.withAlpha(200),
              onPressed: windowManager.close,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      ),
    ),
  );
}

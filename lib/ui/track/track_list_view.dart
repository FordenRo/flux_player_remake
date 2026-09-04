import 'package:flutter/material.dart';

class TrackListView extends StatelessWidget {
  const TrackListView({
    required this.trackCount,
    required this.trackBuilder,
    this.onTrackMoved,
    super.key,
  });

  final int trackCount;
  final void Function(int oldIndex, int newIndex)? onTrackMoved;
  final Widget Function(BuildContext context, int index) trackBuilder;

  @override
  Widget build(BuildContext context) => onTrackMoved == null
      ? ListView.builder(
          itemExtent: 50,
          itemCount: trackCount,
          itemBuilder: trackBuilder,
        )
      : ReorderableListView.builder(
          itemCount: trackCount,
          itemExtent: 50,
          buildDefaultDragHandles: false,
          onReorderItem: onTrackMoved,
          itemBuilder: (context, idx) => ReorderableDragStartListener(
            key: Key(idx.toString()),
            index: idx,
            child: trackBuilder(context, idx),
          ),
        );
}

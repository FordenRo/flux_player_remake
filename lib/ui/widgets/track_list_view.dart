import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import 'track_item.dart';

class TrackListView extends StatefulWidget {
  const new({
    required this.tracks,
    this.onTrackMoved,
    this.onTrackPlayed,
    this.trackActionButtons,
    this.showNext = true,
    this.showDownload = true,
    super.key,
  });

  final List<Track> tracks;
  final void Function(int oldIndex, int newIndex)? onTrackMoved;
  final void Function(int index)? onTrackPlayed;
  final bool showNext;
  final bool showDownload;
  final List<Widget>? trackActionButtons;

  @override
  State<TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<TrackListView> {
  @override
  Widget build(BuildContext context) => widget.onTrackMoved == null
      ? ListView.builder(
          itemExtent: 50,
          itemCount: widget.tracks.length,
          itemBuilder: _itemBuilder,
        )
      : ReorderableListView.builder(
          itemCount: widget.tracks.length,
          itemExtent: 50,
          buildDefaultDragHandles: false,
          onReorderItem: widget.onTrackMoved,
          itemBuilder: (context, idx) => ReorderableDragStartListener(
            key: Key(idx.toString()),
            index: idx,
            child: _itemBuilder(context, idx),
          ),
        );

  Widget _itemBuilder(BuildContext context, int index) => StreamBuilder(
    stream: audioPlayer.stream.currentTrack,
    builder: (context, asyncSnapshot) =>
        audioPlayer.currentTrack == widget.tracks[index]
        ? StreamBuilder(
            stream: audioPlayer.stream.isPlaying,
            builder: (context, asyncSnapshot) => _buildTrack(index),
          )
        : _buildTrack(index),
  );

  TrackItem _buildTrack(int index) {
    final track = widget.tracks[index];
    return TrackItem(
      track,
      isSelected: audioPlayer.currentTrack == track,
      isPlaying: audioPlayer.currentTrack == track && audioPlayer.isPlaying,
      onPlayPressed: widget.onTrackPlayed != null
          ? () => audioPlayer.currentTrack == track && audioPlayer.isPlaying
                ? audioPlayer.pause()
                : widget.onTrackPlayed!(index)
          : null,
      actionButtons: [
        ...?widget.trackActionButtons?.map(
          (e) => Provider.value(value: index, child: e),
        ),
        if (widget.showDownload && track.isRemote) const TrackDownloadAction(),
        if (widget.showNext) const TrackNextAction(),
      ],
    );
  }
}

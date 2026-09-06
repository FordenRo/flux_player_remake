import 'package:flutter/material.dart';

import '../../core/models/track.dart';
import '../../core/services/audio_player.dart';
import 'track_item.dart';
import 'track_list_view_builder.dart';

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
  final void Function(Track track)? onTrackPlayed;
  final bool showNext;
  final bool showDownload;
  final List<Widget>? trackActionButtons;

  @override
  State<TrackListView> createState() => _TrackListViewState();
}

class _TrackListViewState extends State<TrackListView> {
  @override
  Widget build(BuildContext context) => TrackListViewBuilder(
    trackCount: widget.tracks.length,
    trackBuilder: (context, index) {
      final track = widget.tracks[index];
      return StreamBuilder(
        stream: audioPlayer.stream.currentTrack,
        builder: (context, asyncSnapshot) => audioPlayer.currentTrack == track
            ? StreamBuilder(
                stream: audioPlayer.stream.isPlaying,
                builder: (context, asyncSnapshot) => _buildTrack(track),
              )
            : _buildTrack(track),
      );
    },
    onTrackMoved: widget.onTrackMoved,
  );

  TrackItem _buildTrack(Track track) => TrackItem(
    track,
    isSelected: audioPlayer.currentTrack == track,
    isPlaying: audioPlayer.currentTrack == track && audioPlayer.isPlaying,
    onPlayPressed: widget.onTrackPlayed != null
        ? () => audioPlayer.currentTrack == track && audioPlayer.isPlaying
              ? audioPlayer.pause()
              : widget.onTrackPlayed!(track)
        : null,
    actionButtons: [
      ...?widget.trackActionButtons,
      if (widget.showDownload && track.isRemote) const TrackDownloadAction(),
      if (widget.showNext) const TrackNextAction(),
    ],
  );
}

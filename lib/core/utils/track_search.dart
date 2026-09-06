import 'dart:math' show max;

import 'package:fuzzy/fuzzy.dart' show Fuzzy;

import '../models/track.dart';

List<Track> searchTracks(List<Track> tracks, String query) {
  final titleRes = Fuzzy(tracks.map((e) => e.title).toList()).search(query);
  final artistRes = Fuzzy(tracks.map((e) => e.artist).toList()).search(query);

  return tracks
      .where(
        (e) =>
            titleRes.any((r) => r.item == e.title) ||
            artistRes.any((r) => r.item == e.artist),
      )
      .toList()
    ..sort(
      (a, b) =>
          max(
            titleRes.where((e) => e.item == a.title).firstOrNull?.score ?? 0,
            artistRes.where((e) => e.item == a.artist).firstOrNull?.score ?? 0,
          ).compareTo(
            max(
              titleRes.where((e) => e.item == b.title).firstOrNull?.score ?? 0,
              artistRes.where((e) => e.item == b.artist).firstOrNull?.score ??
                  0,
            ),
          ),
    );
}

import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';

import '../../core/models/track.dart';

class TrackDetails extends StatelessWidget {
  const TrackDetails(this.track, {super.key});

  final Track track;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const .all(8),
      child: Card(
        child: Padding(
          padding: const .all(10),
          child: SingleChildScrollView(
            padding: const .all(10),
            child: Column(
              spacing: 16,
              children: [
                const Text('Свойства'),
                _buildDetailEntries(context),
                TextButton(
                  onPressed: () {
                    throw UnimplementedError();
                  },
                  child: const Text('Открыть папку с файлом'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildDetailEntries(BuildContext context) => SizedBox(
    width: 400,
    child: Column(
      spacing: 8,
      children: [
        _DetailEntry(
          'Название',
          value: track.title,
          onSubmitted: (value) => updateMetadata(
            File(track.path),
            (parser) => parser.setTitle(value),
          ),
        ),
        _DetailEntry(
          'Исполнители',
          value: track.artist,
          onSubmitted: (value) => updateMetadata(
            File(track.path),
            (parser) => parser.setArtist(value),
          ),
        ),
        _DetailEntry(
          'Альбом',
          value: track.album,
          onSubmitted: (value) => updateMetadata(
            File(track.path),
            (parser) => parser.setAlbum(value),
          ),
        ),
        _DetailEntry('Путь', value: track.path, readOnly: true),
      ],
    ),
  );
}

class _DetailEntry extends StatelessWidget {
  const new(this.label, {this.value, this.onSubmitted, this.readOnly = false});

  final String label;
  final String? value;
  final bool readOnly;
  final void Function(String value)? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    readOnly: readOnly,
    onSubmitted: onSubmitted,
    controller: .fromValue(.new(text: value ?? '')),
    decoration: .new(labelText: label),
  );
}

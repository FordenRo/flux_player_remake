import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/repositories/library_repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      _LibraryPathsWidget(),
      ListTile(title: Text('Version: 0.1.0')),
    ],
  );
}

class _LibraryPathsWidget extends StatefulWidget {
  const new();

  @override
  State<_LibraryPathsWidget> createState() => _LibraryPathsWidgetState();
}

class _LibraryPathsWidgetState extends State<_LibraryPathsWidget> {
  Future<void> add() async {
    final path = await FilePicker.getDirectoryPath();
    if (path == null) return;

    setState(() => libraryRepository.addPath(path));
  }

  void remove(String path) {
    setState(() => libraryRepository.removePath(path));
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: [
        ListTile(
          title: const Text('Library paths:'),
          trailing: IconButton(
            onPressed: add,
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        ...libraryRepository.getPaths().map(
          (path) => ListTile(
            title: Text(path),
            leading: const Icon(Icons.folder_rounded),
            trailing: IconButton(
              onPressed: () => remove(path),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ),
      ],
    ),
  );
}

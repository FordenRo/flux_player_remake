import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/repositories/library_repository.dart';
import '../../core/services/network_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    children: const [
      _LibraryPathsTile(),
      // ListTile(
      //   title: Text('Путь загрузок'),
      //   leading: Icon(Icons.download_rounded),
      //   trailing: Row(mainAxisSize: .min, children: [Text('Нет')]),
      // ),
      _DownloadPathTile(),
      ListTile(title: Text('Версия'), subtitle: Text('0.1.0')),
    ],
  );
}

class _DownloadPathTile extends StatefulWidget {
  const new();

  @override
  State<_DownloadPathTile> createState() => _DownloadPathTileState();
}

class _DownloadPathTileState extends State<_DownloadPathTile> {
  Future<void> edit() async {
    final path = await FilePicker.getDirectoryPath();
    setState(() => networkService.downloadPath = path);
  }

  @override
  Widget build(BuildContext context) => ListTile(
    title: const Text('Путь загрузок'),
    subtitle: Text(networkService.downloadPath ?? 'Нет'),
    trailing: IconButton(onPressed: edit, icon: const Icon(Icons.edit_rounded)),
  );
}

class _LibraryPathsTile extends StatefulWidget {
  const new();

  @override
  State<_LibraryPathsTile> createState() => _LibraryPathsTileState();
}

class _LibraryPathsTileState extends State<_LibraryPathsTile> {
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
          title: const Text('Пути библиотеки'),
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

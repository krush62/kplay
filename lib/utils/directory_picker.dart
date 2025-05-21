import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DirectoryPicker extends StatefulWidget {
  final Function(String dir) onDirectorySelected;
  final Function() discard;
  static String? lastDir;

  const DirectoryPicker({super.key, required this.onDirectorySelected, required this.discard});


  @override
  State<DirectoryPicker> createState() => _DirectoryPickerState();
}

class _DirectoryPickerState extends State<DirectoryPicker>
{
  final ValueNotifier<Directory?> currentDir = ValueNotifier<Directory?>(null);

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((final Directory dir) {
      currentDir.value = dir;
      if (DirectoryPicker.lastDir != null)
      {
        if (Directory(DirectoryPicker.lastDir!).existsSync())
        {
          currentDir.value = Directory(DirectoryPicker.lastDir!);
        }
      }
    });
  }

  InkWell _getRow({required final Directory dir, required final Function(Directory dir) onTap, final String? title})
  {
    return InkWell(
      onTap: () {onTap(dir);},
      child: Row(
        children: <Widget>[
          const Icon(Icons.folder, size: 32,),
          const SizedBox(width: 16,),
          Text(title ?? path.basename(dir.path), style: const TextStyle(fontSize: 32),),
        ],
      ),
    );
  }

  void _directorySelected(final Directory dir)
  {
    if (currentDir.value == null || dir.path != currentDir.value?.path)
    {
      currentDir.value = dir;
      DirectoryPicker.lastDir = dir.path;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ValueListenableBuilder<Directory?>(
            valueListenable: currentDir,
            builder: (final BuildContext context, final Directory? dir, final Widget? child) {
              if (dir == null)
              {
                return const SizedBox.shrink();
              }
              else
              {
                return Text(dir.path, style: const TextStyle(fontSize: 24),);
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ValueListenableBuilder<Directory?>(
                valueListenable: currentDir,
                builder: (final BuildContext context, final Directory? dir, final Widget? child) {
                  if (dir == null)
                  {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else
                  {
                    final List<Widget> rows = <Widget>[];
                    rows.add(_getRow(dir: dir.parent, onTap: _directorySelected, title: ".."));

                    final List<FileSystemEntity> subDirs = dir.listSync();
                    // get the subdirectories
                    for (final FileSystemEntity d in subDirs) {
                      if (d is Directory) {
                        rows.add(_getRow(dir: d, onTap: _directorySelected));
                      }
                    }
                    return Column(
                      children: rows,
                    );
                  }
                },
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: IconButton.filled(
                  onPressed: () {
                    widget.discard();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  icon: const Text("CANCEL", ),
                ),
              ),
              const SizedBox(width: 16,),
              Expanded(
                child: ValueListenableBuilder<Directory?>(
                  valueListenable: currentDir,
                  builder: (final BuildContext context, final Directory? dir, final Widget? child) {
                    if (dir == null)
                    {
                      return const SizedBox.shrink();
                    }
                    else
                    {
                      return IconButton.filled(
                        onPressed: () {
                          widget.onDirectorySelected(dir.path);
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        icon: const Text("USE THIS FOLDER"),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

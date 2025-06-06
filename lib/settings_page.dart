
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kplay/main.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/directory_picker.dart';
import 'package:kplay/utils/file_helper.dart';
import 'package:kplay/utils/helpers.dart';
import 'package:path/path.dart' as p;

class SettingsPage extends StatefulWidget
{
  const SettingsPage({super.key, required this.errorCallback, required this.allPlaylistTracks, required this.favoritePlaylistTracks, required this.baseFolderNotifier});

  final void Function({required String message, int seconds}) errorCallback;
  final ValueNotifier<List<MutableTrack>> allPlaylistTracks;
  final ValueNotifier<List<MutableTrack>> favoritePlaylistTracks;
  final ValueNotifier<List<TableBaseFolder>> baseFolderNotifier;


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
{
  final int _textTruncateChars = 48;

  final ValueNotifier<String?> _currentStatus = ValueNotifier<String?>(null);
  final ValueNotifier<bool> _loadingDialogIsVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _extensionM4a = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _extensionOgg = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _extensionMp3 = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _extensionOpus = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _extensionFlac = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _scanRecursive = ValueNotifier<bool>(true);
  bool _minimumOverlayTimerRunning = false;

  late OverlayEntry _alertOverlay;
  late OverlayEntry _directoryPickerOverlay;


  @override
  void initState() 
  {
    super.initState();
    _alertOverlay = OverlayEntry(
      builder: (final BuildContext context) {
        return Stack(
          children:<Widget>[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withAlpha(100),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: <Widget>[
                          const CircularProgressIndicator(),
                          const SizedBox(width: 20,),
                          ValueListenableBuilder<String?>(
                              valueListenable: _currentStatus,
                              builder: (final BuildContext context, final String? status, final Widget? child)
                              {
                                return Text(status ?? "finishing...");
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    _directoryPickerOverlay = OverlayEntry(
      builder: (final BuildContext context) {
        return Stack(
          children:<Widget>[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withAlpha(100),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: DirectoryPicker(onDirectorySelected: _newFolderSelected, discard: _discardDirectoryPicker),
                ),
              ),
            ),
          ],
        );
      },
    );


    _currentStatus.addListener(_statusChange);
    _loadingDialogIsVisible.addListener(_loadingDialogIsVisibleChange);
    _readBaseFolders();
  }

  void _statusChange()
  {
    final bool shouldBeVisible = (_currentStatus.value != null);
    if (_loadingDialogIsVisible.value != shouldBeVisible)
    {
      _loadingDialogIsVisible.value = shouldBeVisible;
    }
  }

  void _loadingDialogIsVisibleChange()
  {
    if (_loadingDialogIsVisible.value)
    {
      Overlay.of(context).insert(_alertOverlay);
      _minimumOverlayTimerRunning = true;
      Timer(const Duration(milliseconds: 500), () {
        _minimumOverlayTimerRunning = false;
        if (!_loadingDialogIsVisible.value)
        {
          _loadingDialogIsVisibleChange();
        }
      });
    }
    else if (!_minimumOverlayTimerRunning)
    {
      _alertOverlay.remove();
    }
  }


  bool baseFoldersAreDifferent(final List<TableBaseFolder> items)
  {
    if (widget.baseFolderNotifier.value.length != items.length)
    {
      return true;
    }
    for (int i = 0; i < items.length; i++) {
      if (widget.baseFolderNotifier.value[i].title != items[i].title) {
        return true;
      }
    }
    return false;
  }

  void _readBaseFolders()
  {
    appdb.select(appdb.tableBaseFolders).get().then((final List<TableBaseFolder> items) {
      if (baseFoldersAreDifferent(items))
      {
        widget.baseFolderNotifier.value = items;
        _updatePlaylists();
      }
    });
  }

  void _updatePlaylists()
  {
    appdb.getAllTracks().then((final List<TableTrack> tracks) {
      final List<MutableTrack> allTracks = <MutableTrack>[];
      final List<MutableTrack> favoriteTracks = <MutableTrack>[];
      for (final TableTrack track in tracks)
      {
        allTracks.add(MutableTrack.fromTableTrack(track));
        if (track.isFavorite)
        {
          favoriteTracks.add(MutableTrack.fromTableTrack(track));
        }
      }
      widget.allPlaylistTracks.value = allTracks;
      widget.favoritePlaylistTracks.value = favoriteTracks;
    });
  }

  
  void _onRefresh()
  {
    final List<String> extensions = <String>[];
    if (_extensionM4a.value) extensions.add(".m4a");
    if (_extensionOgg.value) extensions.add(".ogg");
    if (_extensionMp3.value) extensions.add(".mp3");
    if (_extensionOpus.value) extensions.add(".opus");
    if (_extensionFlac.value) extensions.add(".flac");
    _currentStatus.value = "Reading base folders...";
    getAllMetaData(extensions: extensions, baseFolders: widget.baseFolderNotifier.value, recursive: _scanRecursive.value, updateLabelNotifier: _currentStatus).then((final List<TableTracksCompanion> tracks) {
      _filesReadFromBaseFolders(tracks: tracks);
    });
  }

  void _filesReadFromBaseFolders({required final List<TableTracksCompanion> tracks})
  {
    _currentStatus.value = "Updating database...";
    appdb.insertTracks(tracks: tracks).then((final bool success) {

      _updatePlaylists();
      _currentStatus.value = null;
    });
  }


  void _addNewFolderPressed()
  {
    Overlay.of(context).insert(_directoryPickerOverlay);
  }

  void _newFolderSelected(final String path)
  {
    _directoryPickerOverlay.remove();
    appdb.insertBaseFolder(path).then((final bool success) {
      if (success)
      {
        _readBaseFolders();
      }
      else
      {
        widget.errorCallback(message: "Error: Could not add new folder");
      }
    });
  }

  void _discardDirectoryPicker()
  {
    _directoryPickerOverlay.remove();
  }



  void _deleteFolder(final TableBaseFolder folder)
  {
    _currentStatus.value = "Removing base folder...";
    appdb.deleteBaseFolder(folder).then((final bool success) {
      if (success)
      {
        _currentStatus.value = null;
        _readBaseFolders();
      }
      else
      {
        widget.errorCallback(message: "Error: Could not delete folder");
      }
    });
  }

  @override
  Widget build(final BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[

        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text("Source Folders", style: Theme.of(context).textTheme.titleLarge),
                      ),
                      ValueListenableBuilder<List<TableBaseFolder>>(
                        valueListenable: widget.baseFolderNotifier,
                        builder: (final BuildContext context, final List<TableBaseFolder> baseFolders, final Widget? child) 
                        {
                          final List<Widget> children = <Widget>[];
                          for (final TableBaseFolder baseFolder in baseFolders)
                          {

                            final Row row = Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(truncateFront(text: p.basename(baseFolder.title), maxChars: _textTruncateChars), style: Theme.of(context).textTheme.titleMedium,),
                                const SizedBox(width: 16,),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: IconButton.filledTonal(
                                    onPressed: () {
                                      _deleteFolder(baseFolder);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                  ),
                                ),
                              ],
                            );

                            children.add(row);
                            if (baseFolders.last != baseFolder)
                            {
                              children.add(const Divider(height: 16,));
                            }
                            else
                            {
                              children.add(const SizedBox(height: 8,));
                            }

                          }
                          children.add(IconButton.filledTonal(onPressed: _addNewFolderPressed, icon: const Icon(Icons.add,)));
                          children.add(const SizedBox(height: 8,));
                          return Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children));
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 4,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Recursive", style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _scanRecursive,
                            builder: (final BuildContext context, final bool value, final Widget? child)
                            {
                              return CheckboxListTile(
                                value: value,
                                onChanged: (final bool? value) {
                                  _scanRecursive.value = value ?? false;
                                },
                              );
                            },
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 4,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text("Extensions", style: Theme.of(context).textTheme.headlineMedium),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch, 
                          children: <Widget>[
                            ValueListenableBuilder<bool>(
                              valueListenable: _extensionFlac,
                              builder: (final BuildContext context, final bool value, final Widget? child)
                              {
                                return CheckboxListTile(
                                  value: value,
                                  onChanged: (final bool? value) {
                                    _extensionFlac.value = value ?? false;
                                  },
                                  title: Text("flac", style: Theme.of(context).textTheme.titleLarge),
                                );
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _extensionM4a,
                              builder: (final BuildContext context, final bool value, final Widget? child)
                              {
                                return CheckboxListTile(
                                  value: value,
                                  onChanged: (final bool? value) {
                                    _extensionM4a.value = value ?? false;
                                  },
                                  title: Text("m4a", style: Theme.of(context).textTheme.titleLarge),
                                );
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _extensionMp3,
                              builder: (final BuildContext context, final bool value, final Widget? child)
                              {
                                return CheckboxListTile(
                                  value: value,
                                  onChanged: (final bool? value) {
                                    _extensionMp3.value = value ?? false;
                                  },
                                  title: Text("mp3", style: Theme.of(context).textTheme.titleLarge),
                                );
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _extensionOgg,
                              builder: (final BuildContext context, final bool value, final Widget? child)
                              {
                                return CheckboxListTile(
                                  value: value,
                                  onChanged: (final bool? value) {
                                    _extensionOgg.value = value ?? false;
                                  },
                                  title: Text("ogg", style: Theme.of(context).textTheme.titleLarge),
                                );
                              },
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: _extensionOpus,
                              builder: (final BuildContext context, final bool value, final Widget? child)
                              {
                                return CheckboxListTile(
                                  value: value,
                                  onChanged: (final bool? value) {
                                    _extensionOpus.value = value ?? false;
                                  },
                                  title: Text("opus", style: Theme.of(context).textTheme.titleLarge),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ColoredBox(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: IconButton.filledTonal(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh, size: 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

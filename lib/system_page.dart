
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage>
{
  final Duration _brightnessSetterInterval = const Duration(milliseconds: 100);
  final double _bottomIconSize = 48.0;
  final ValueNotifier<double> _brightness = ValueNotifier<double>(255.0);
  int _lastTransmittedValue = -1;
  final ValueNotifier<bool> _displayFound = ValueNotifier<bool>(false);
  String? _brightnessFilePath;
  Timer? _brightnessSetTimer;

  @override
  void initState()
  {
    super.initState();
    _findDisplay().then((final int? brightness) {
      if (brightness != null)
      {
        _brightness.value = brightness.toDouble();
        _displayFound.value = true;
        _brightnessSetTimer = Timer.periodic(_brightnessSetterInterval, _brightnessSetTimerCallback);
      }
    });
  }

  void _brightnessSetTimerCallback(final Timer timer)
  {
    if (_lastTransmittedValue != _brightness.value.toInt())
    {
      writeBrightness(_brightness.value.toInt()).then((_) {
        _lastTransmittedValue = _brightness.value.toInt();
      });
    }
    else
    {
      timer.cancel();
    }
  }

  Future<void> writeBrightness(final int brightness) async
  {
    if (_brightnessFilePath != null)
    {
      stdout.writeln("Setting brightness to $brightness");
      await Process.run("echo", <String>[brightness.toString(), "|", "tee", _brightnessFilePath!]);
    }
  }

  @override
  void dispose() {
    _brightnessSetTimer?.cancel();
    super.dispose();
  }

  Future<void> _onExit() async
  {
    if (Platform.isLinux)
    {
      await Process.start("killall", <String>["vlc"], mode: ProcessStartMode.detached);
    }
    exit(0);
  }

  Future<void> _onShutdown() async
  {
    if (Platform.isLinux)
    {
      await Process.start("shutdown", <String>["-h", "now"], mode: ProcessStartMode.detached);
    }
    else
    {
      await Process.start("shutdown", <String>["/s"], mode: ProcessStartMode.detached);
    }
  }

  Future<int?> _findDisplay() async
  {
    final Directory backlightDir = Directory("/sys/class/backlight");
    if (!await backlightDir.exists())
    {
      stdout.writeln("Backlight directory not found: ${backlightDir.path}");
      return null;
    }
    final List<FileSystemEntity> files = await backlightDir.list().toList();
    final List<Directory> directories = files.whereType<Directory>().toList();
    if (directories.length != 1)
    {
      stdout.writeln("Backlight directory contains more than one directory: ${backlightDir.path}");
      return null;
    }
    final List<FileSystemEntity> deviceFiles = await directories[0].list().toList();
    final File? brightnessFile = deviceFiles.where((final FileSystemEntity element) => p.basename(element.path) == "brightness").whereType<File>().toList().firstOrNull;
    if (brightnessFile == null)
    {
      stdout.writeln("Brightness file not found: ${directories[0].path}");
      return null;
    }
    stdout.writeln("Brightness file found: ${brightnessFile.path}");
    _brightnessFilePath = brightnessFile.path;

    final File? actualBrightnessFile = deviceFiles.where((final FileSystemEntity element) => p.basename(element.path) == "actual_brightness").whereType<File>().toList().firstOrNull;
    if (actualBrightnessFile == null)
    {
      stdout.writeln("Actual brightness file not found: ${directories[0].path}");
      return null;
    }
    else
    {
      final String brightnessString = await actualBrightnessFile.readAsString();
      return int.tryParse(brightnessString);
    }
  }


  void _setBrightnessSlider(final double value)
  {
    _brightness.value = value;
    _brightnessSetTimer = Timer.periodic(_brightnessSetterInterval, _brightnessSetTimerCallback);
  }

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text("Brightness", style: TextStyle(fontSize: 24),),
          ValueListenableBuilder<bool>(
            valueListenable: _displayFound,
            builder: (final BuildContext context, final bool displayFound, final Widget? child)
            {
              return ValueListenableBuilder<double>(
                valueListenable: _brightness,
                builder: (final BuildContext context, final double brightness, final Widget? child) {
                  return Slider(
                    max: 255.0,
                    value: brightness,
                    onChanged: displayFound ? _setBrightnessSlider : null,
                  );
                },
              );
            },
          ),
          const Expanded(
              child: SizedBox.shrink(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton.filled(
                    onPressed: _onExit,
                    icon: Icon(Icons.logout, size: _bottomIconSize),
                ),
                IconButton.filled(
                    onPressed: _onShutdown,
                    icon: Icon(Icons.power_settings_new, size: _bottomIconSize),
                ),
              ],
          ),
        ],
      ),
    );
  }
}

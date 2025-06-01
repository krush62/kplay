
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kplay/utils/audio_player_state.dart';
import 'package:kplay/utils/database.dart';

class SystemPage extends StatefulWidget {
  const SystemPage({super.key});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage>
{
  static const double _iconSize = 64.0;
  static const double _padding = 16.0;
  static const List<String> _chromeParametersPre = <String>["--no-sandbox", "--kiosk"];
  static const List<String> _chromeParametersPost = <String>["--noerrdialogs", "--disable-infobars", "--disable-session-crashed-bubble"];
  static const String _chromePathWin = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe";
  static const String _youtubeUrl = "https://youtube.com";
  static const String _musicUrl = "https://music.youtube.com";
  static final ValueNotifier<String> _ipAddress = ValueNotifier<String>("");
  static final ValueNotifier<int> _trackCount = ValueNotifier<int>(0);

  @override
  void initState()
  {
    super.initState();
    _updateIpAddress();
    _getTrackCount();
  }


  Future<void> _onExit() async
  {
    await AudioPlayerState.killVlc();
    if (Platform.isLinux)
    {
      await Process.start("killall", <String>["vlc"], mode: ProcessStartMode.detached);
    }
    exit(0);
  }

  Future<void> _onShutdown() async
  {
    await AudioPlayerState.killVlc();
    if (Platform.isLinux)
    {
      await Process.start("shutdown", <String>["-h", "now"], mode: ProcessStartMode.detached);
    }
    else
    {
      await Process.start("shutdown", <String>["/s"], mode: ProcessStartMode.detached);
    }
  }

  Future<void> _onYoutubeStart() async
  {
    await AudioPlayerState.pause();
    if (Platform.isLinux)
    {
      exit(2);
    }
    else
    {
      await Process.start(_chromePathWin, <String>[ ..._chromeParametersPre, _youtubeUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
  }

  Future<void> _onMusicStart() async
  {
    await AudioPlayerState.pause();
    if (Platform.isLinux)
    {
      exit(3);
    }
    else
    {
      await Process.start(_chromePathWin, <String>[ ..._chromeParametersPre, _musicUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
  }

  Future<void> _updateIpAddress() async
  {
    if (Platform.isLinux)
    {
      final ProcessResult result = await Process.run("hostname", <String>["-I"]);
      if (result.exitCode == 0)
      {
        final String stdOut = result.stdout.toString();
        final List<String> ipList = stdOut.split(" ");
        if (ipList.isNotEmpty)
        {
          _ipAddress.value = ipList[0];
        }
        else
        {
          _ipAddress.value = stdOut;
        }
      }
    }
    else
    {
      final ProcessResult result = await Process.run(
        'powershell',
        <String>[
          '-Command',
          "(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { \$_.AddressState -eq 'Preferred' -and \$_.PrefixOrigin -eq 'Dhcp' } | Select-Object -ExpandProperty IPAddress)",
        ],
      );
      if (result.exitCode == 0)
      {
       _ipAddress.value = result.stdout.toString().replaceAll("\n", " ");
      }
    }
  }

  Future<void> _getTrackCount() async
  {
    _trackCount.value = AppDatabase.trackCount;
  }


  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        children: <Widget>[
          const Expanded(
            child: SizedBox.shrink(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: _padding + _iconSize,
                height: _padding + _iconSize,
                child: IconButton.filledTonal(
                  onPressed: _onYoutubeStart,
                  icon: const Icon(Icons.ondemand_video, size: _iconSize),
                ),
              ),
              SizedBox(
                width: _padding + _iconSize,
                height: _padding + _iconSize,
                child: IconButton.filledTonal(
                  onPressed: _onMusicStart,
                  icon: const Icon(Icons.music_video, size: _iconSize),
                ),
              ),
            ],
          ),
          const Expanded(
              child: SizedBox.shrink(),
          ),
          ValueListenableBuilder<String>(
            valueListenable: _ipAddress,
            builder: (final BuildContext context, final String ip, final Widget? child) {
              return Text("IP Address: $ip", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),);
            },
          ),
          ValueListenableBuilder<String>(
            valueListenable: AudioPlayerState.password,
            builder: (final BuildContext context, final String password, final Widget? child) {
              return Text("VLC Password: $password", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),);
            },
          ),
          ValueListenableBuilder<PlaybackState>(
            valueListenable: AudioPlayerState.playbackState,
            builder: (final BuildContext context, final PlaybackState state, final Widget? child) {
              return Text("VLC State: ${state.name}", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),);
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _trackCount,
            builder: (final BuildContext context, final int count, final Widget? child) {
              return Text("Track Count: $count", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),);
            },
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: _padding + _iconSize,
                  height: _padding + _iconSize,
                  child: IconButton.filled(
                      onPressed: _onExit,
                      icon: const Icon(Icons.logout, size: _iconSize),
                  ),
                ),
                SizedBox(
                  width: _padding + _iconSize,
                  height: _padding + _iconSize,
                  child: IconButton.filled(
                      onPressed: _onShutdown,
                      icon: const Icon(Icons.power_settings_new, size: _iconSize),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}


import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kplay/utils/audio_player_state.dart';

class SystemPage extends StatefulWidget {
  final AudioPlayerState audioPlayerState;
  const SystemPage({super.key, required this.audioPlayerState});

  @override
  State<SystemPage> createState() => _SystemPageState();
}

class _SystemPageState extends State<SystemPage>
{
  final double _iconSize = 64.0;
  final double _padding = 16.0;
  final List<String> _chromeParametersPre = <String>["--no-sandbox", "--kiosk"];
  final List<String> _chromeParametersPost = <String>["--noerrdialogs", "--disable-infobars", "--disable-session-crashed-bubble"];
  final String _chromePathWin = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe";
  final String _chromePathLinux = "/usr/bin/chromium";
  final String _youtubeUrl = "https://youtube.com";
  final String _musicUrl = "https://music.youtube.com";

  @override
  void initState()
  {
    super.initState();
  }


  Future<void> _onExit() async
  {
    await widget.audioPlayerState.killVlc();
    if (Platform.isLinux)
    {
      await Process.start("killall", <String>["vlc"], mode: ProcessStartMode.detached);
    }
    exit(0);
  }

  Future<void> _onShutdown() async
  {
    await widget.audioPlayerState.killVlc();
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
    await widget.audioPlayerState.pause();
    if (Platform.isLinux)
    {
      await Process.start("startx", <String>[_chromePathLinux, ..._chromeParametersPre, _youtubeUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
    else
    {
      await Process.start(_chromePathWin, <String>[ ..._chromeParametersPre, _youtubeUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
  }

  Future<void> _onMusicStart() async
  {
    await widget.audioPlayerState.pause();
    if (Platform.isLinux)
    {
      await Process.start("startx", <String>[_chromePathLinux, ..._chromeParametersPre, _musicUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
    else
    {
      await Process.start(_chromePathWin, <String>[ ..._chromeParametersPre, _musicUrl, ..._chromeParametersPost], mode: ProcessStartMode.detached);
    }
  }


  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_padding),
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
                  icon: Icon(Icons.ondemand_video, size: _iconSize),
                ),
              ),
              SizedBox(
                width: _padding + _iconSize,
                height: _padding + _iconSize,
                child: IconButton.filledTonal(
                  onPressed: _onMusicStart,
                  icon: Icon(Icons.music_video, size: _iconSize),
                ),
              ),
            ],
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
                      icon: Icon(Icons.logout, size: _iconSize),
                  ),
                ),
                SizedBox(
                  width: _padding + _iconSize,
                  height: _padding + _iconSize,
                  child: IconButton.filled(
                      onPressed: _onShutdown,
                      icon: Icon(Icons.power_settings_new, size: _iconSize),
                  ),
                ),
              ],
          ),
        ],
      ),
    );
  }
}

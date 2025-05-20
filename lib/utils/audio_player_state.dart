

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kplay/utils/helpers.dart';


enum PlaybackState
{
  stopped,
  playing,
  paused,
  disconnected
}

const Map<String, PlaybackState> _vlcPlaybackStateMap = <String, PlaybackState>{
  "stopped": PlaybackState.stopped,
  "playing": PlaybackState.playing,
  "paused": PlaybackState.paused,
};

class AudioBackendState
{
  final PlaybackState playbackState;
  final int duration;
  final int position;
  final int volume;

  AudioBackendState({required this.playbackState, required this.duration, required this.position, required this.volume});

  factory AudioBackendState.empty()
  {
    return AudioBackendState(playbackState: PlaybackState.disconnected, duration: 0, position: 0, volume: 0);
  }

  factory AudioBackendState.fromJson(final String jsonString)
  {
    const String STATE_FIELD = "state";
    const String LENGTH_FIELD = "length";
    const String TIME_FIELD = "time";
    const String VOLUME_FIELD = "volume";

    final dynamic decoded = json.decode(jsonString);
    if (decoded is Map<String, dynamic>)
    {
       if ((decoded.containsKey(STATE_FIELD) && decoded[STATE_FIELD] is String && _vlcPlaybackStateMap.containsKey(decoded[STATE_FIELD])) &&
           (decoded.containsKey(LENGTH_FIELD) && decoded[LENGTH_FIELD] is int)  &&
           (decoded.containsKey(TIME_FIELD) && decoded[TIME_FIELD] is int) &&
           (decoded.containsKey(VOLUME_FIELD) && decoded[VOLUME_FIELD] is int))
       {
        return AudioBackendState(playbackState: _vlcPlaybackStateMap[decoded[STATE_FIELD]]!, duration: decoded[LENGTH_FIELD]! as int, position: decoded[TIME_FIELD]! as int, volume: decoded[VOLUME_FIELD]! as int);
       }
       else
       {
         return AudioBackendState.empty();
       }
    }
    else
    {
      return AudioBackendState.empty();
    }
  }
}

class AudioPlayerState
{
  late Timer _queryTimer;
  late Process _vlcProcess;
  final ValueNotifier<AudioBackendState> playbackState = ValueNotifier<AudioBackendState>(AudioBackendState.empty());
  static const Duration _QUERY_INTERVAL = Duration(milliseconds: 500);
  static const double _CURL_TIMEOUT_SECONDS = 0.2;
  final String _password = generatePassword(length: 12);

  void _queryTimeout(final Timer timer)
  {
    _getVlcState();
  }

  Future<void> _getVlcState() async
  {
    final String executable = Platform.isWindows ? "curl.exe" : "curl";
    final ProcessResult curlResult = await Process.run(executable, <String>["--connect-timeout", "$_CURL_TIMEOUT_SECONDS", "-u", ":$_password", "http://localhost:8080/requests/status.json"]);
    if (curlResult.exitCode == 0)
    {
      playbackState.value = AudioBackendState.fromJson(curlResult.stdout.toString());
    }
    else
    {
      print(curlResult.stderr);
    }
  }

  AudioPlayerState()
  {
    _startVLC().then((final bool result) {
      if (result)
      {
        _queryTimer = Timer.periodic(_QUERY_INTERVAL, _queryTimeout);
      }
    },);
  }

  //TODO kill timer and process (? there are no destructors)

  Future<bool> _startVLC() async
  {
    final String executable = Platform.isWindows ? "C:\\Program Files\\VideoLAN\\VLC\\vlc.exe" : "vlc";
    try
    {
      _vlcProcess = await Process.start(executable, <String>["-I", "http", "--http-password=$_password"], mode: ProcessStartMode.detached);
      return true;
    }
    catch(_)
    {
      return false;
    }

  }



}

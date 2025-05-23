

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/helpers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum PlaybackState
{
  stopped,
  playing,
  paused,
  disconnected
}

class PlaylistEntry
{
  final MutableTrack dbTrack;
  final String playlistId;

  PlaylistEntry({required this.dbTrack, required this.playlistId});
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
  final double positionFactor;
  final int volume;
  final PlaylistEntry? currentTrack;

  AudioBackendState({required this.playbackState, required this.duration, required this.position, required this.volume, required this.currentTrack, required this.positionFactor});

  factory AudioBackendState.empty()
  {
    return AudioBackendState(playbackState: PlaybackState.disconnected, duration: 0, position: 0, volume: 0, currentTrack: null, positionFactor: 0.0);
  }

  factory AudioBackendState.fromJson(final String jsonString, final List<PlaylistEntry> playlist)
  {
    const String stateField = "state";
    const String lengthField = "length";
    const String timeField = "time";
    const String volumeField = "volume";
    const String playlistIdField = "currentplid";
    const String positionField = "position";

    try
    {
      final dynamic decoded = json.decode(jsonString);
      if (decoded is Map<String, dynamic>)
      {
        if ((decoded.containsKey(stateField) && decoded[stateField] is String && _vlcPlaybackStateMap.containsKey(decoded[stateField])) &&
            (decoded.containsKey(lengthField) && decoded[lengthField] is int)  &&
            (decoded.containsKey(timeField) && decoded[timeField] is int) &&
            (decoded.containsKey(volumeField) && decoded[volumeField] is int) &&
            (decoded.containsKey(playlistIdField) && decoded[playlistIdField] is int) &&
            (decoded.containsKey(positionField) && (decoded[positionField] is double || decoded[positionField] is int))
        )
        {

          double positionFactor = 0.0;
          if (decoded[positionField] is int)
          {
            positionFactor = (decoded[positionField] as int).toDouble();
          }
          else if (decoded[positionField] is double)
          {
            positionFactor = decoded[positionField] as double;
          }

          PlaylistEntry? currentTrack;
          if (decoded[playlistIdField] != -1)
          {
            currentTrack = playlist.where((final PlaylistEntry entry) => entry.playlistId == decoded[playlistIdField].toString()).singleOrNull;
          }

          return AudioBackendState(
            playbackState: _vlcPlaybackStateMap[decoded[stateField]]!,
            duration: decoded[lengthField]! as int,
            position: decoded[timeField]! as int,
            volume: decoded[volumeField]! as int,
            currentTrack: currentTrack,
            positionFactor: positionFactor,);
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
    catch(_)
    {
      return AudioBackendState.empty();
    }
  }
}

class AudioPlayerState
{
  final ValueNotifier<AudioBackendState> audioBackendState = ValueNotifier<AudioBackendState>(AudioBackendState.empty());
  final ValueNotifier<PlaybackState> playbackState = ValueNotifier<PlaybackState>(PlaybackState.disconnected);
  final ValueNotifier<double> audioPositionFactor = ValueNotifier<double>(0.0);
  final ValueNotifier<int> duration = ValueNotifier<int>(0);
  static const Duration queryInterval = Duration(milliseconds: 500);
  static const double curlTimeout = 0.3;
  final String _password = generatePassword(length: 12);
  final ValueNotifier<List<PlaylistEntry>> playlist = ValueNotifier<List<PlaylistEntry>>(<PlaylistEntry>[]);
  final String _curlCommand = Platform.isWindows ? "curl.exe" : "curl";
  final String _vlcCommand = Platform.isWindows ? "C:\\Program Files\\VideoLAN\\VLC\\vlc.exe" : "vlc";
  bool initialized = false;

  AudioPlayerState()
  {
    _startVLC().then((final bool result) {
      initialized = true;
      if (result)
      {
        Timer.periodic(queryInterval, _queryTimeout);
      }
    },);
  }

  void _queryTimeout(final Timer timer)
  {
    _getVlcState();
  }

  Future<void> _getVlcState() async
  {
    final ProcessResult curlResult = await Process.run(_curlCommand, <String>["--connect-timeout", "$curlTimeout", "-u", ":$_password", "http://localhost:8080/requests/status.json"]);
    if (curlResult.exitCode == 0)
    {
      audioBackendState.value = AudioBackendState.fromJson(curlResult.stdout.toString(), playlist.value);
      playbackState.value = audioBackendState.value.playbackState;
      audioPositionFactor.value = audioBackendState.value.positionFactor;
      duration.value = audioBackendState.value.duration;
    }
    else
    {
      stdout.writeln("Could not retrieve VLC state!");
    }
  }


  //TODO kill timer and process (? there are no destructors)

  Future<bool> _startVLC() async
  {
    try
    {
      stdout.writeln("PASSWORD: $_password");
      await Process.start(_vlcCommand, <String>["-I", "http", "--http-password=$_password"], mode: ProcessStartMode.detached);
      return true;
    }
    catch(_)
    {
      return false;
    }
  }

  Future<void> setPlaylist({required final List<MutableTrack> playlistFromDB}) async
  {
    await clearPlaylist();

    final StringBuffer m3uBuffer = StringBuffer();
    m3uBuffer.writeln("#EXTM3U");
    for (final MutableTrack track in playlistFromDB)
    {
      final String urlPath = Uri.encodeFull(track.path.replaceAll("\\", "/"));
      m3uBuffer.writeln("file:///$urlPath");
    }
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final String m3u8Name = "playlist_$timestamp.m3u8";
    final Directory supportDir = await getApplicationCacheDirectory();
    if (!await supportDir.exists()) {
      await supportDir.create(recursive: true);
    }

    final String fileName = p.join(supportDir.path, m3u8Name);

    final File file = File(fileName);
    await file.writeAsString(m3uBuffer.toString());
    final String escapedM3uPath = Uri.encodeFull(fileName.replaceAll("\\", "/"));
    await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=in_enqueue&input=file:///$escapedM3uPath"]);
    const int waitTimeSeconds = 4;
    stdout.writeln("Waiting for VLC for $waitTimeSeconds seconds");
    await Future<void>.delayed(const Duration(seconds: waitTimeSeconds));
    await next();
    await pause();

    for (int i = 0; i < 10; i++)
    {
      final ProcessResult playlistResult = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/playlist.json"]);
      if (playlistResult.exitCode == 0)
      {
        final String jsonString = playlistResult.stdout.toString();
        final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;

        final List<String> leafIds = <String>[];
        _collectLeafIds(data, leafIds);
        if (leafIds.length == playlistFromDB.length)
        {
          final List<PlaylistEntry> entries = <PlaylistEntry>[];
          for (int i = 0; i < playlistFromDB.length; i++)
          {
            entries.add(PlaylistEntry(dbTrack: playlistFromDB[i], playlistId: leafIds[i]));
          }
          playlist.value = entries;
          break;
        }
        else
        {
          stdout.writeln("Different number of playlist ids! Expected: ${playlistFromDB.length}, got: ${leafIds.length}");
        }
      }
      else
      {
        stdout.writeln("Could not retrieve playlist!");
      }
      stdout.writeln("Retrying in 500ms...");
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    stdout.writeln("Setting playlist finished!");
  }

  void _collectLeafIds(final Map<String, dynamic> node, final List<String> leafIds) {
    if (node['type'] == 'leaf') {
      leafIds.add(node['id'] as String);
    }

    if (node.containsKey('children')) {
      final List<dynamic>children = node['children'] as List<dynamic>;
      for (final dynamic child in children) {
        if (child is Map<String, dynamic>) {
          _collectLeafIds(child, leafIds);
        }
      }
    }
  }

  Future<bool> play() async
  {
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_play"]);
    return (result.exitCode == 0);
  }

  Future<bool> pause() async
  {
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_pause"]);
    return (result.exitCode == 0);
  }

  Future<bool> next() async
  {
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_next"]);
    return (result.exitCode == 0);
  }

  Future<bool> previous() async
  {
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_previous"]);
    return (result.exitCode == 0);
  }

  Future<bool> seek(final double position) async
  {
    final int secondPosition = (position.clamp(0.0, 1.0) * audioBackendState.value.duration.toDouble()).toInt();
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=seek&val=$secondPosition"]);
    return (result.exitCode == 0);
  }

  Future<bool> selectTrack(final MutableTrack track) async
  {
    final String? playlistId = playlist.value.where((final PlaylistEntry entry) => entry.dbTrack.id == track.id).singleOrNull?.playlistId;
    if (playlistId != null)
    {
      final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_play&id=$playlistId"]);
      return (result.exitCode == 0);
    }
    return false;
  }

  Future<bool> clearPlaylist() async
  {
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=pl_empty"]);
    return (result.exitCode == 0);
  }

  Future<bool> shuffle(final bool enabled) async
  {
    final String command = enabled ? "pl_random" : "pl_repeat";
    final ProcessResult result = await Process.run(_curlCommand, <String>["-u", ":$_password", "http://localhost:8080/requests/status.json?command=$command"]);
    return (result.exitCode == 0);
  }

}

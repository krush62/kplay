

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/helpers.dart';
import 'package:path/path.dart' as p;


class SimpleTrackInfo {
  final String album;
  final String artist;
  final String title;

  SimpleTrackInfo({required this.album, required this.artist, required this.title});
}

class ExtendedTrackInfo {
  String? title;
  String? album;
  String? artist;
  String? albumArtist;
  int? pubYear;
  int? duration;
}

SimpleTrackInfo _extractTrackInfo(final String filePath)
{
  String fileName = filePath.split(Platform.pathSeparator).last;
  fileName = fileName.substring(0, fileName.lastIndexOf('.'));
  final int dashIndex = fileName.indexOf(' - ');
  if (dashIndex == -1) {
    final String directoryPath = Directory(filePath).parent.path;
    return SimpleTrackInfo(
        album: directoryPath.split(Platform.pathSeparator).last,
        artist: "${directoryPath.split(Platform.pathSeparator).last} Team",
        title: fileName,);
  }
  final String artist = fileName.substring(0, dashIndex).trim();
  final String titleWithAlbum = fileName.substring(dashIndex + 3).trim(); //+3 to remove ' - '
  String album = "";
  String title = "";
  final int lastOpenParenthesis = titleWithAlbum.lastIndexOf('(');
  if (lastOpenParenthesis != -1)
  {
    final int lastCloseParenthesis = titleWithAlbum.lastIndexOf(')');
    if (lastCloseParenthesis > lastOpenParenthesis)
    {
      album = titleWithAlbum.substring(lastOpenParenthesis + 1, lastCloseParenthesis).trim();
      title = titleWithAlbum.substring(0, lastOpenParenthesis).trim();
    }
  }
  if (album.isEmpty)
  {
    final String directoryPath = Directory(filePath).parent.path;
    album = directoryPath.split(Platform.pathSeparator).last;
    title = titleWithAlbum.trim();
  }

  return SimpleTrackInfo(album: album, artist:artist, title: title);
}

Future<Uint8List?> getImageForTrack({required final String path}) async
{
  Uint8List? imageData;

  final Map<String, String>
  extensionMap = <String, String>{
    ".m4a": "coverart",
    ".mp3": "Picture",
    ".ogg": "Picture",
    ".opus": "Picture",
    ".flac": "Picture",
  };
  final String extension = p.extension(path).toLowerCase();
  if (extensionMap.containsKey(extension))
  {
    final String arg = extensionMap[extension]!;
    try
    {
      final ProcessResult exifToolResult = await Process.run("exiftool", <String>["-b", "-$arg", path], stdoutEncoding: null);

      if (exifToolResult.exitCode == 0 && exifToolResult.stdout is Uint8List)
      {
        imageData = exifToolResult.stdout as Uint8List;
      }

    }
    catch (e)
    {
      stdout.writeln("Error reading image for file $path");
    }
  }


  return imageData;

}

Future<ExtendedTrackInfo?> getExifInfo({required final String path}) async
{
  final String extension = p.extension(path).toLowerCase();

  const int albumIndex = 0;
  const int titleIndex = 1;
  const int artistIndex = 2;
  const int albumArtistIndex = 3;
  const int yearIndex = 4;
  const int durationIndex = 5;

  final List<String> mp3Fields = List<String>.filled(6, "");
  final List<String> m4aFields = List<String>.filled(6, "");
  final List<String> oggFields = List<String>.filled(5, "");

  mp3Fields[albumIndex] = "-album";
  mp3Fields[titleIndex] = "-title";
  mp3Fields[artistIndex] = "-artist";
  mp3Fields[albumArtistIndex] = "-band";
  mp3Fields[yearIndex] = "-year";
  mp3Fields[durationIndex] = "-duration";

  m4aFields[albumIndex] = "-album";
  m4aFields[titleIndex] = "-title";
  m4aFields[artistIndex] = "-artist";
  m4aFields[albumArtistIndex] = "-albumartist";
  m4aFields[yearIndex] = "-contentcreatedate";
  m4aFields[durationIndex] = "-duration";

  oggFields[albumIndex] = "-album";
  oggFields[titleIndex] = "-title";
  oggFields[artistIndex] = "-artist";
  oggFields[albumArtistIndex] = "-albumartist";
  oggFields[yearIndex] = "-date";

  final Map<String, List<String>>
  extensionMap = <String, List<String>>
  {
    ".mp3": mp3Fields,
    ".m4a": m4aFields,
    ".ogg": oggFields,
    ".opus": oggFields,
    ".flac": oggFields,
  };

  if (extensionMap.containsKey(extension))
  {
    final List<String> infoFields = extensionMap[extension]!;
    final ExtendedTrackInfo extInfo = ExtendedTrackInfo();

    try
    {
      final ProcessResult exifToolResult = await Process.run('exiftool', <String>[...infoFields, '-s2', path]);
      if (exifToolResult.exitCode == 0)
      {
        final String resultString = exifToolResult.stdout.toString();
        const LineSplitter ls = LineSplitter();
        final List<String> resultList = ls.convert(resultString);
        int infoStartIndex = 0;
        for (final String resultEntry in resultList)
        {
          for (int i = infoStartIndex; i < infoFields.length; i++)
          {
            if (resultEntry.toLowerCase().startsWith(infoFields[i].substring(1)))
            {
              final String data = resultEntry.substring(infoFields[i].length + 1).trim();
              if (i == albumIndex) {extInfo.album = data;}
              else if (i == titleIndex) {extInfo.title = data;}
              else if (i == artistIndex) {extInfo.artist = data;}
              else if (i == albumArtistIndex) {extInfo.albumArtist = data;}
              else if (i == yearIndex)
              {
                final int? parseResult = int.tryParse(data);
                if (parseResult != null) extInfo.pubYear = parseResult;
              }
              else if (i == durationIndex)
              {
                final RegExp timeRegex = RegExp(r'(\d+):(\d+):(\d+)');
                final RegExpMatch? match = timeRegex.firstMatch(data);
                if (match != null)
                {
                  final int hours = int.parse(match.group(1)!);
                  final int minutes = int.parse(match.group(2)!);
                  final int seconds = int.parse(match.group(3)!);
                  final int totalSeconds = hours * 3600 + minutes * 60 + seconds;
                  extInfo.duration = totalSeconds;
                }
              }
              infoStartIndex = i + 1;
              break;
            }
          }
        }
      }
    }
    catch (e)
    {
      return null;
    }

    //get duration
    if (extInfo.duration == null)
    {
      try
      {
        final ProcessResult ffProbeResult = await Process.run('ffprobe', <String>['-v', 'error', '-show_entries', 'format=duration', '-of', 'default=noprint_wrappers=1:nokey=1', path]);
        if (ffProbeResult.exitCode == 0) {
          final double? parsed = double.tryParse(ffProbeResult.stdout.toString().trim());
          if (parsed != null) {
            extInfo.duration = parsed.toInt();
          }
          else
          {
            throw Exception();
          }
        }
      }
      catch (e)
      {
        extInfo.duration = 0;
        stdout.writeln("Could not determine duration for file $path");
        //return null;
      }
    }

    return extInfo;
  }
  else
  {
    return null;
  }
}


Future<List<TableTracksCompanion>> getAllMetaData({required final List<String> extensions, required  final List<TableBaseFolder> baseFolders, required final bool recursive, required final ValueNotifier<String?> updateLabelNotifier}) async
{
  final List<TableTracksCompanion> tracks = <TableTracksCompanion>[];
  for (final TableBaseFolder baseFolder in baseFolders)
  {
    final Set<String> paths = await _getFileListFromFolder(folder: baseFolder.title, recursive: recursive, extensions: extensions);
    for (final String path in paths)
    {
      updateLabelNotifier.value = 'Scanning: " ${truncateFront(text: path, maxChars: 64)}"';
      TableTracksCompanion? track;
      final SimpleTrackInfo trackInfo = _extractTrackInfo(path);

      final ExtendedTrackInfo? exTrack = await getExifInfo(path: path);
      if (exTrack != null)
      {
        track = TableTracksCompanion.insert(
          baseFolderId: baseFolder.id,
          title: exTrack.title ?? trackInfo.title,
          artist: exTrack.artist ?? trackInfo.artist,
          album: exTrack.album ?? trackInfo.album,
          albumArtist: exTrack.albumArtist ?? (exTrack.album != null ? "${exTrack.album!} Team" : "${exTrack.album} Team"),
          path: path,
          pubYear: exTrack.pubYear ?? 1970,
          duration: exTrack.duration ?? 0,
          isFavorite: false,
        );
      }
      else
      {
        track = TableTracksCompanion.insert(
          baseFolderId: baseFolder.id,
          title: trackInfo.title,
          artist: trackInfo.artist,
          album: trackInfo.album,
          albumArtist: "${trackInfo.album} Team",
          path: path,
          pubYear: 1970,
          duration: 0,
          isFavorite: false,
        );
      }

      tracks.add(track);
    }
  }
  return tracks;
}


Future<Set<String>> _getFileListFromFolder({required final String folder, required final bool recursive, required final List<String> extensions}) async
{
  final Directory dir = Directory(folder);
  final Set<String> files = <String>{};

  await for (final FileSystemEntity entity in dir.list(recursive: recursive, followLinks: false))
  {
    if (entity is File)
    {
      final File file = entity;
      final String extension = p.extension(file.path);
      if (extensions.contains(extension))
      {
        files.add(file.path);
      }
    }
  }

  return files;
}

Future<bool> deleteFile({required final String path}) async
{
  try
  {
    final File file = File(path);
    await file.delete();
    return true;
  }
  catch (e)
  {
    return false;
  }

}
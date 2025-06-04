
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kplay/main.dart';
import 'package:kplay/utils/audio_player_state.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/file_helper.dart';
import 'package:kplay/utils/helpers.dart';
import 'package:marquee/marquee.dart';



class PlayerPage extends StatefulWidget
{
  const PlayerPage({super.key, required this.imageData, required this.currentTrack, required this.playlistType, required this.toggleFavorite, required this.allPlaylistTracks});

  final Function() toggleFavorite;
  final ValueNotifier<Uint8List?> imageData;
  final ValueNotifier<MutableTrack?> currentTrack;
  final ValueNotifier<PlaylistType> playlistType;
  final ValueNotifier<List<MutableTrack>> allPlaylistTracks;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
{
  static const double favoriteHeight = 28;
  static const double padding = 8;
  late OverlayEntry _alertOverlay;

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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Do you want to delete this track?", style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.errorContainer),),
                          const SizedBox(height: 16,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                             SizedBox(
                               width: 128,
                               height: 64,
                               child: IconButton.filledTonal(onPressed: (){_deleteTrackDeclined();}, icon: const Icon(Icons.cancel, size: 48,)),
                             ),
                             const SizedBox(width: 32,),
                             SizedBox(
                                 width: 128,
                                 height: 64,
                                 child: IconButton.filledTonal(onPressed: (){_deleteTrackAccepted();}, icon: const Icon(Icons.check, size: 48)),
                             ),
                           ],
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
  }

  Future<void> _playPressed() async
  {
    AudioPlayerState.audioBackendState.value.playbackState == PlaybackState.playing ? await AudioPlayerState.pause() : await AudioPlayerState.play();
  }

  void _nextPressed()
  {
    AudioPlayerState.next();
  }

  void _previousPressed()
  {
    AudioPlayerState.previous();
  }

  Widget _getAppropriateTextWidget({required final String displayText, required final double maxWidth, required final TextStyle? textStyle})
  {
    final TextSpan span = TextSpan(
      text: displayText,
      style: textStyle,
    );
    final TextPainter tp = TextPainter(
      maxLines: 1,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      text: span,
    );

    tp.layout(maxWidth: maxWidth);
    if (tp.didExceedMaxLines)
    {
      return SizedBox(
        height: tp.height,
        child: Marquee(
          style: textStyle,
          fadingEdgeStartFraction: 0.2,
          fadingEdgeEndFraction: 0.2,
          text: displayText,
          crossAxisAlignment: CrossAxisAlignment.start,
          blankSpace: 50.0,
          velocity: tp.height,
        ),
      );
    }
    else
    {
      return Text(displayText, style: textStyle, maxLines: 1,);
    }
  }

  void _longPressOnTitle()
  {
    Overlay.of(context).insert(_alertOverlay);
  }

  void _deleteTrackAccepted()
  {
    _deleteTrack().then((final void _) {
      _alertOverlay.remove();
    },);
  }

  Future<void> _deleteTrack() async
  {
    final MutableTrack track = widget.currentTrack.value!;
    await AudioPlayerState.next();
    if (await AudioPlayerState.removeTrackFromPlaylist(track))
    {
      widget.allPlaylistTracks.value.remove(track);
      if (await appdb.deleteTrack(track))
      {
        deleteFile(path: track.path);
      }
      else if (context.mounted)
      {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to remove track from database!"),));
      }
    }
    else if (context.mounted)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to remove track from playlist!"),));
    }

  }

  void _deleteTrackDeclined()
  {
    _alertOverlay.remove();
  }


  @override
  Widget build(final BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: ValueListenableBuilder<Uint8List?>(
                    valueListenable: widget.imageData,
                    builder: (final BuildContext context, final Uint8List? imageData, final Widget? child)
                    {
                      if (imageData != null)
                      {
                        return Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Theme.of(context).colorScheme.tertiary,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withAlpha(200),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.memory(imageData, fit: BoxFit.contain,),
                            ),
                          ),
                        );
                      }
                      else
                      {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Icon(Icons.music_note, size: 128, color: Theme.of(context).colorScheme.onSecondaryFixed,),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 32,),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Expanded(child: SizedBox.shrink()),
                          ValueListenableBuilder<MutableTrack?>(
                            valueListenable: widget.currentTrack,
                            builder: (final BuildContext context, final MutableTrack? track, final Widget? child)
                            {
                              Icon icon;
                              if (track != null && track.isFavorite)
                              {
                                icon = Icon(Icons.favorite, size: favoriteHeight, color: Theme.of(context).colorScheme.onSecondary,);
                              }
                              else
                              {
                                icon = Icon(Icons.favorite_border, size: favoriteHeight, color: Theme.of(context).colorScheme.onSecondary,);
                              }

                              return ValueListenableBuilder<PlaylistType>(
                                valueListenable: widget.playlistType,
                                builder: (final BuildContext context, final PlaylistType playlistType, final Widget? child) {
                                  if (playlistType == PlaylistType.favorite)
                                  {
                                    return const SizedBox(height: favoriteHeight + padding,);
                                  }
                                  else
                                  {
                                    return SizedBox(
                                      height: favoriteHeight + padding,
                                      width: favoriteHeight + padding,
                                      child: IconButton(
                                        onPressed: track != null ? () {
                                          widget.toggleFavorite();
                                        } : null,
                                        icon: icon,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      ValueListenableBuilder<MutableTrack?>(
                        valueListenable: widget.currentTrack,
                        builder: (final BuildContext context, final MutableTrack? track, final Widget? child)
                        {
                          return LayoutBuilder(
                            builder: (final BuildContext context, final BoxConstraints constraints) {
                              final String trackTitle = track != null ? track.title : "Track Title";
                              final String trackAlbum = track != null ? track.album : "Album Title";
                              final String trackArtist = track != null ?  "${track.albumArtist} (${track.pubYear}) - ${track.artist}" : "";
                              return Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onLongPress: () {_longPressOnTitle();},
                                    child: _getAppropriateTextWidget(
                                      displayText: trackTitle,
                                      maxWidth: constraints.maxWidth,
                                      textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        shadows: <Shadow>[
                                          Shadow(
                                            blurRadius: 8.0,
                                            color: Colors.black.withAlpha(200),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  _getAppropriateTextWidget(
                                    displayText: trackAlbum,
                                    maxWidth: constraints.maxWidth,
                                    textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.tertiary,
                                      shadows: <Shadow>[
                                        Shadow(
                                          blurRadius: 6.0,
                                          color: Colors.black.withAlpha(160),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4,),
                                  _getAppropriateTextWidget(
                                    displayText: trackArtist,
                                    maxWidth: constraints.maxWidth,
                                    textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primaryContainer),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 4,),
                      const Expanded(child: SizedBox.shrink()),
                      ValueListenableBuilder<MutableTrack?>(
                        valueListenable: widget.currentTrack,
                        builder: (final BuildContext context, final MutableTrack? track, final Widget? child) {
                          const double iconSize = 64;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                onPressed: track != null ? _previousPressed : null,
                                icon: Icon(
                                  Icons.skip_previous,
                                  size: iconSize,
                                  color: Theme.of(context).colorScheme.primary,
                                  shadows: const <Shadow>[
                                    Shadow(
                                      blurRadius: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                              ValueListenableBuilder<PlaybackState>(
                                valueListenable: AudioPlayerState.playbackState,
                                  builder: (final BuildContext context, final PlaybackState playbackState, final Widget? child)
                                  {
                                    Icon? icon;
                                    if (playbackState == PlaybackState.playing)
                                    {
                                      icon = Icon(
                                        Icons.pause,
                                        size: iconSize,
                                        color: Theme.of(context).colorScheme.primary,
                                        shadows: const <Shadow>[
                                          Shadow(
                                            blurRadius: 16.0,
                                          ),
                                        ],
                                      );
                                    }
                                    else if (playbackState == PlaybackState.paused || playbackState == PlaybackState.stopped)
                                    {
                                      icon = Icon(
                                        Icons.play_arrow,
                                        size: iconSize,
                                        color: Theme.of(context).colorScheme.primary,
                                        shadows: const <Shadow>[
                                          Shadow(
                                            blurRadius: 16.0,
                                          ),
                                        ],
                                      );
                                    }
                                    else
                                    {
                                      icon = Icon(
                                        Icons.question_mark,
                                        size: iconSize,
                                        color: Theme.of(context).colorScheme.errorContainer,
                                        shadows: const <Shadow>[
                                          Shadow(
                                            blurRadius: 16.0,
                                          ),
                                        ],
                                      );
                                    }
                                    return IconButton(
                                      onPressed: playbackState != PlaybackState.disconnected ? _playPressed : null,
                                      icon: icon,
                                    );
                                  },
                              ),

                              IconButton(
                                onPressed: track != null ? _nextPressed : null,
                                icon: Icon(
                                  Icons.skip_next,
                                  size: iconSize,
                                  color: Theme.of(context).colorScheme.primary,
                                  shadows: const <Shadow>[
                                    Shadow(
                                      blurRadius: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      //const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),
          ValueListenableBuilder<double>(
              valueListenable: AudioPlayerState.audioPositionFactor,
              builder: (final BuildContext context, final double position, final Widget? child) {
                return Slider(
                  value: position,
                  onChanged: (final double value) {
                    AudioPlayerState.seek(value);
                  },
                );
              },
          ),

          ValueListenableBuilder<int>(
            valueListenable: AudioPlayerState.duration,
            builder: (final BuildContext context, final int duration, final Widget? child) {
              return Row(
                children: <Widget>[
                  ValueListenableBuilder<double>(
                      valueListenable: AudioPlayerState.audioPositionFactor,
                      builder: (final BuildContext context, final double position, final Widget? child) {
                        return Text(formatDuration(seconds: (position * duration.toDouble()).toInt()), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary));
                      },
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Text(formatDuration(seconds: duration), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

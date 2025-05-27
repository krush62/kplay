
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kplay/main.dart';
import 'package:kplay/utils/audio_player_state.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/helpers.dart';
import 'package:marquee/marquee.dart';



class PlayerPage extends StatefulWidget
{
  const PlayerPage({super.key, required this.audioPlayerState, required this.imageData, required this.currentTrack, required this.playlistType, required this.toggleFavorite});

  final Function() toggleFavorite;
  final ValueNotifier<Uint8List?> imageData;
  final AudioPlayerState audioPlayerState;
  final ValueNotifier<MutableTrack?> currentTrack;
  final ValueNotifier<PlaylistType> playlistType;


  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage>
{
  
  @override
  void initState()
  {
    super.initState();
  }

  Future<void> _playPressed() async
  {
    widget.audioPlayerState.audioBackendState.value.playbackState == PlaybackState.playing ? await widget.audioPlayerState.pause() : await widget.audioPlayerState.play();
  }

  void _nextPressed()
  {
    widget.audioPlayerState.next();
  }

  void _previousPressed()
  {
    widget.audioPlayerState.previous();
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(imageData, fit: BoxFit.contain,),
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
                              const double favoriteHeight = 28;
                              const double padding = 8;
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
                                  _getAppropriateTextWidget(displayText: trackTitle, maxWidth: constraints.maxWidth, textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                                  _getAppropriateTextWidget(displayText: trackAlbum, maxWidth: constraints.maxWidth, textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
                                  const SizedBox(height: 4,),
                                  _getAppropriateTextWidget(displayText: trackArtist, maxWidth: constraints.maxWidth, textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.primaryContainer)),
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
                              IconButton(onPressed: track != null ? _previousPressed : null, icon: Icon(Icons.skip_previous, size: iconSize, color: Theme.of(context).colorScheme.primary,),
                              ),
                              ValueListenableBuilder<PlaybackState>(
                                valueListenable: widget.audioPlayerState.playbackState,
                                  builder: (final BuildContext context, final PlaybackState playbackState, final Widget? child)
                                  {
                                    Icon? icon;
                                    if (playbackState == PlaybackState.playing)
                                    {
                                      icon = Icon(Icons.pause, size: iconSize, color: Theme.of(context).colorScheme.primary,);
                                    }
                                    else if (playbackState == PlaybackState.paused || playbackState == PlaybackState.stopped)
                                    {
                                      icon = Icon(Icons.play_arrow, size: iconSize, color: Theme.of(context).colorScheme.primary);
                                    }
                                    else
                                    {
                                      icon = Icon(Icons.question_mark, size: iconSize, color: Theme.of(context).colorScheme.errorContainer);
                                    }
                                    return IconButton(onPressed: playbackState != PlaybackState.disconnected ? _playPressed : null, icon: icon);
                                  },
                              ),

                              IconButton(onPressed: track != null ? _nextPressed : null, icon: Icon(Icons.skip_next, size: iconSize, color: Theme.of(context).colorScheme.primary)),
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
              valueListenable: widget.audioPlayerState.audioPositionFactor,
              builder: (final BuildContext context, final double position, final Widget? child) {
                return Slider(
                  value: position,
                  onChanged: (final double value) {
                    widget.audioPlayerState.seek(value);
                  },
                );
              },
          ),

          ValueListenableBuilder<int>(
            valueListenable: widget.audioPlayerState.duration,
            builder: (final BuildContext context, final int duration, final Widget? child) {
              return Row(
                children: <Widget>[
                  ValueListenableBuilder<double>(
                      valueListenable: widget.audioPlayerState.audioPositionFactor,
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

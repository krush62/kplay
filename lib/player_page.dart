
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kplay/main.dart';
import 'package:kplay/utils/audio_player_state.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/helpers.dart';

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



  @override
  Widget build(final BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                                icon = Icon(Icons.favorite, size: 32, color: Theme.of(context).colorScheme.onSecondary,);
                              }
                              else
                              {
                                icon = Icon(Icons.favorite_border, size: 32, color: Theme.of(context).colorScheme.onSecondary,);
                              }

                              return ValueListenableBuilder<PlaylistType>(
                                valueListenable: widget.playlistType,
                                builder: (final BuildContext context, final PlaylistType playlistType, final Widget? child) {
                                  if (playlistType == PlaylistType.favorite)
                                  {
                                    return const SizedBox(height: 32,);
                                  }
                                  else
                                  {
                                    return IconButton(
                                      onPressed: track != null ? () {
                                        widget.toggleFavorite();
                                      } : null,
                                      icon: icon,
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
                          return Column(
                            children: <Widget>[
                              Text(track != null ? track.title : "Track Title", style: Theme.of(context).textTheme.displaySmall),
                              Text(track != null ? track.album : "Album Title", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.primary)),
                              Text(track != null ? track.albumArtist : "Album Artist", style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.secondary)),
                            ],
                          );
                        },
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      ValueListenableBuilder<MutableTrack?>(
                        valueListenable: widget.currentTrack,
                        builder: (final BuildContext context, final MutableTrack? track, final Widget? child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(onPressed: track != null ? _previousPressed : null, icon: const Icon(Icons.skip_previous, size: 72,)),
                              const SizedBox(width: 16,),
                              ValueListenableBuilder<PlaybackState>(
                                valueListenable: widget.audioPlayerState.playbackState,
                                  builder: (final BuildContext context, final PlaybackState playbackState, final Widget? child)
                                  {
                                    Icon? icon;
                                    if (playbackState == PlaybackState.playing)
                                    {
                                      icon = const Icon(Icons.pause, size: 72,);
                                    }
                                    else if (playbackState == PlaybackState.paused || playbackState == PlaybackState.stopped)
                                    {
                                      icon = const Icon(Icons.play_arrow, size: 72,);
                                    }
                                    else
                                    {
                                      icon = const Icon(Icons.question_mark, size: 72,);
                                    }
                                    return IconButton(onPressed: playbackState != PlaybackState.disconnected ? _playPressed : null, icon: icon);
                                  },
                              ),

                              const SizedBox(width: 16,),
                              IconButton(onPressed: track != null ? _nextPressed : null, icon: const Icon(Icons.skip_next, size: 72,)),
                            ],
                          );
                        },
                      ),
                      const Expanded(child: SizedBox.shrink()),
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
                        return Text(formatDuration(seconds: (position * duration.toDouble()).toInt()), style: Theme.of(context).textTheme.bodyLarge);
                      },
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  Text(formatDuration(seconds: duration), style: Theme.of(context).textTheme.bodyLarge),
                ],
              );

            },
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:kplay/main.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/helpers.dart';

class PlaylistPage extends StatefulWidget
{
  final ValueNotifier<List<MutableTrack>> allPlaylistTracks;
  final ValueNotifier<List<MutableTrack>> favoritePlaylistTracks;
  final ValueNotifier<PlaylistType> playlistType;
  final ValueNotifier<MutableTrack?> currentTrack;
  final void Function ({required MutableTrack track}) selectTrack;
  const PlaylistPage({super.key, required this.allPlaylistTracks, required this.favoritePlaylistTracks, required this.playlistType, required this.currentTrack, required this.selectTrack});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage>
{
  @override
  void initState() 
  {    
    super.initState();
  }

  @override
  Widget build(final BuildContext context)
  {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ValueListenableBuilder<PlaylistType>(
          valueListenable: widget.playlistType,
          builder: (final BuildContext context, final PlaylistType type, final Widget? child)
          {
            return SegmentedButton<PlaylistType>(
              onSelectionChanged: (final Set<PlaylistType> p0) {
                widget.playlistType.value = p0.first;
              },
              showSelectedIcon: false,
              segments:
                const <ButtonSegment<PlaylistType>>[
                  ButtonSegment<PlaylistType>(
                    icon: Icon(Icons.reorder, size: 32,),
                    value: PlaylistType.all,
                    label: Text("All"),
                  ),
                  ButtonSegment<PlaylistType>(
                    icon: Icon(Icons.favorite, size: 27),
                    value: PlaylistType.favorite,
                    label: Text("Favorite"),
                  ),
                ],
                selected: <PlaylistType>{type},
            );
          },
        ),
        Expanded(
          child: ValueListenableBuilder<PlaylistType>(
            valueListenable: widget.playlistType,
            builder: (final BuildContext context, final PlaylistType type, final Widget? child)
            {
              if (type == PlaylistType.all)
              {
                return ValueListenableBuilder<MutableTrack?>(
                  valueListenable: widget.currentTrack,
                  builder: (final BuildContext context, final MutableTrack? currentTrack, final Widget? child)
                  {
                    return ListView.builder(
                      itemCount: widget.allPlaylistTracks.value.length,
                      itemBuilder: (final BuildContext context, final int index)
                      {
                        final ListTile tile = ListTile(
                          selected: widget.allPlaylistTracks.value[index] == currentTrack,
                          title: Text(widget.allPlaylistTracks.value[index].title, maxLines: 1,),
                          subtitle: Text(widget.allPlaylistTracks.value[index].albumArtist, maxLines: 1,),
                          trailing: Text(formatDuration(seconds: widget.allPlaylistTracks.value[index].duration)),
                          leading: const Icon(Icons.music_note, size: 32,),
                          onTap: () {widget.selectTrack(track: widget.allPlaylistTracks.value[index]);},
                        );
                        if (index == 0 || widget.allPlaylistTracks.value[index].album != widget.allPlaylistTracks.value[index - 1].album)
                        {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ColoredBox(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("${widget.allPlaylistTracks.value[index].album} (${widget.allPlaylistTracks.value[index].pubYear})", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.apply(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                                ),
                              ),
                              tile,
                            ],
                          );
                        }
                        else
                        {
                          return tile;
                        }
                      },
                    );
                  },
                );
              }
              else //FAVORITES
              {
                return ValueListenableBuilder<MutableTrack?>(
                  valueListenable: widget.currentTrack,
                  builder: (final BuildContext context, final MutableTrack? currentTrack, final Widget? child)
                  {
                    return ListView.builder(
                      itemCount: widget.favoritePlaylistTracks.value.length,
                      itemBuilder: (final BuildContext context, final int index)
                      {
                        return ListTile(
                          selected: widget.favoritePlaylistTracks.value[index] == currentTrack,
                          title: Text(widget.favoritePlaylistTracks.value[index].title, maxLines: 1,),
                          subtitle: Text(widget.favoritePlaylistTracks.value[index].album, maxLines: 1,),
                          trailing: Text(formatDuration(seconds: widget.favoritePlaylistTracks.value[index].duration)),
                          leading: const Icon(Icons.music_note, size: 32,),
                          onTap: () {widget.selectTrack(track: widget.allPlaylistTracks.value[index]);},
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

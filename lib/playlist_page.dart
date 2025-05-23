

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
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(4)),
              ),
              expandedInsets: EdgeInsets.zero,
              showSelectedIcon: false,
              segments:
                 <ButtonSegment<PlaylistType>>[
                  ButtonSegment<PlaylistType>(
                    icon: const Icon(Icons.reorder, size: 20,),
                    value: PlaylistType.all,
                    label: Text("All", style: Theme.of(context).textTheme.titleLarge),
                  ),
                  ButtonSegment<PlaylistType>(
                    icon: const Icon(Icons.favorite, size: 18),
                    value: PlaylistType.favorite,
                    label: Text("Favorite", style: Theme.of(context).textTheme.titleLarge),
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
                          //contentPadding: const EdgeInsets.only(left: 8, right: 8),
                          selected: widget.allPlaylistTracks.value[index] == currentTrack,
                          title: Text(widget.allPlaylistTracks.value[index].title, maxLines: 1, style: Theme.of(context).textTheme.titleMedium,),
                          subtitle: Text(widget.allPlaylistTracks.value[index].albumArtist, maxLines: 1, style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
                          trailing: Text(formatDuration(seconds: widget.allPlaylistTracks.value[index].duration), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
                          leading: const Icon(Icons.music_note, size: 32,),
                          onTap: () {widget.selectTrack(track: widget.allPlaylistTracks.value[index]);},
                          minTileHeight: 20,
                          minVerticalPadding: 4,

                        );
                        if (index == 0 || widget.allPlaylistTracks.value[index].album != widget.allPlaylistTracks.value[index - 1].album)
                        {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ColoredBox(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                child: Text("${widget.allPlaylistTracks.value[index].album} (${widget.allPlaylistTracks.value[index].pubYear})", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium!.apply(color: Theme.of(context).colorScheme.onPrimaryContainer)),
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

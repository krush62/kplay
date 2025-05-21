import 'dart:typed_data';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:kplay/kplay_theme.dart';
import 'package:kplay/player_page.dart';
import 'package:kplay/playlist_page.dart';
import 'package:kplay/settings_page.dart';
import 'package:kplay/system_page.dart';
import 'package:kplay/utils/audio_player_state.dart';
import 'package:kplay/utils/database.dart';
import 'package:kplay/utils/file_helper.dart';

late AppDatabase appdb;

void main() async
{
  appdb = AppDatabase();
  runApp(const MyApp());
  doWhenWindowReady(() {
    const Size initialSize = Size(800, 480);
    appWindow.minSize = initialSize;
    appWindow.maxSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context)
  {
    //final Brightness brightness = View.of(context).platformDispatcher.platformBrightness;
    final TextTheme textTheme = createTextTheme(context, "Homenaje", "Homenaje");
    final MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'KPlay',
      //theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      theme: theme.dark(),
      home: const KPlay(),
    );
  }
}

enum NavigationState
{
  player,
  browser,
  settings,
  system
}


class KPlay extends StatefulWidget
{
  const KPlay({super.key});

  @override
  State<KPlay> createState() => _KPlayState();
}

enum PlaylistType
{
  all,
  favorite
}

class _KPlayState extends State<KPlay>
{
  final AudioPlayerState audioPlayerState = AudioPlayerState();
  final ValueNotifier<NavigationState> _selectedNavigation = ValueNotifier<NavigationState>(NavigationState.player);
  final List<Widget> _navigationDestinations = <Widget>[];
  final Map<int, NavigationState> _navigationStateMap =
  <int, NavigationState>{
    0: NavigationState.player,
    1: NavigationState.browser,
    2: NavigationState.settings,
    3: NavigationState.system,
  };

  final Map<NavigationState, int> _navigationStateMapReverse =
  <NavigationState, int>{
    NavigationState.player: 0,
    NavigationState.browser: 1,
    NavigationState.settings: 2,
    NavigationState.system: 3,
  };

  final Map<NavigationState, IconData> _navigationIconMap =
  <NavigationState, IconData>{
    NavigationState.player: Icons.music_note,
    NavigationState.browser: Icons.queue_music_sharp,
    NavigationState.settings: Icons.settings_sharp,
    NavigationState.system: Icons.power_settings_new,
  };

  final Map<NavigationState, String> _navigationTitleMap =
  <NavigationState, String>{
    NavigationState.player: "Player",
    NavigationState.browser: "Browser",
    NavigationState.settings: "Settings",
    NavigationState.system: "System",
  };

  final ValueNotifier<List<MutableTrack>> allPlaylistTracks = ValueNotifier<List<MutableTrack>>(<MutableTrack>[]);
  final ValueNotifier<List<MutableTrack>> favoritePlaylistTracks = ValueNotifier<List<MutableTrack>>(<MutableTrack>[]);
  final ValueNotifier<Uint8List?> imageData = ValueNotifier<Uint8List?>(null);
  final ValueNotifier<PlaylistType> playlistType = ValueNotifier<PlaylistType>(PlaylistType.all);
  final ValueNotifier<MutableTrack?> currentTrack = ValueNotifier<MutableTrack?>(null);

  late OverlayEntry _playlistLoadOverlay;
  static const Duration _waitTimeForAudioPlayer = Duration(seconds: 5);

  @override
  void initState()
  {
    super.initState();

    _playlistLoadOverlay = OverlayEntry(
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
                      child: const Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 20,),
                          Text("loading playlist..."),
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

    for (final NavigationState state in _navigationStateMap.values)
    {
      final NavigationDestination destination = NavigationDestination(
        icon: Icon(_navigationIconMap[state]),
        label: _navigationTitleMap[state] ?? "",
        tooltip: _navigationTitleMap[state] ?? "",
      );
      _navigationDestinations.add(destination);
    }
    _setupListeners();
    appdb.databaseCheck().then((final bool success) {databaseTestFinished(success);});
  }

  void _setupListeners()
  {
    allPlaylistTracks.addListener(()
    {
      if (playlistType.value == PlaylistType.all)
      {
        //Overlay.of(context).insert(_playlistLoadOverlay);
        _populatePlayerPlaylist(tracks: allPlaylistTracks.value).then((_) {
          _playlistCreationFinished();
        },);
      }
    });

    favoritePlaylistTracks.addListener(()
    {
      if (playlistType.value == PlaylistType.favorite)
      {
        //Overlay.of(context).insert(_playlistLoadOverlay);
        _populatePlayerPlaylist(tracks: favoritePlaylistTracks.value).then((_) {
          _playlistCreationFinished();
        },);
      }
    });

    playlistType.addListener(() {
      if (playlistType.value == PlaylistType.all)
      {
        //Overlay.of(context).insert(_playlistLoadOverlay);
        _populatePlayerPlaylist(tracks: allPlaylistTracks.value).then((_) {
          _playlistCreationFinished();
        },);
      }
      else if (playlistType.value == PlaylistType.favorite)
      {
        //Overlay.of(context).insert(_playlistLoadOverlay);
        _populatePlayerPlaylist(tracks: favoritePlaylistTracks.value).then((_) {
          _playlistCreationFinished();
        },);
      }
    },);

    audioPlayerState.audioBackendState.addListener(() {
      if (audioPlayerState.audioBackendState.value.currentTrack != null && currentTrack.value != audioPlayerState.audioBackendState.value.currentTrack!.dbTrack)
      {
        currentTrack.value = audioPlayerState.audioBackendState.value.currentTrack!.dbTrack;
        getImageForTrack(path: currentTrack.value!.path).then((final Uint8List? data) {imageData.value = data;});
      }
    },);
  }

  void _playlistCreationFinished()
  {
    if (_playlistLoadOverlay.mounted)
    {
      _playlistLoadOverlay.remove();
    }
  }

  Future<void> toggleFavorite() async
  {
    if (currentTrack.value != null)
    {
      final TableTrack? updatedTrack = await appdb.toggleFavorite(currentTrack.value!.id, currentTrack.value!.isFavorite);
      if (updatedTrack != null)
      {
        currentTrack.value = MutableTrack.fromTableTrack(updatedTrack);

        if (audioPlayerState.audioBackendState.value.currentTrack != null)
        {
          audioPlayerState.audioBackendState.value.currentTrack!.dbTrack.isFavorite = updatedTrack.isFavorite;
        }

        final List<TableTrack> favoriteTracks = await appdb.getFavoriteTracks();
        final List<MutableTrack> favoriteTracksMutable = <MutableTrack>[];
        for (final TableTrack track in favoriteTracks)
        {
          favoriteTracksMutable.add(MutableTrack.fromTableTrack(track));
        }
        favoritePlaylistTracks.value = favoriteTracksMutable;
      }
    }
  }

  Future<void> _populatePlayerPlaylist({required final List<MutableTrack> tracks}) async
  {
    //CHECK IF THE PLAYLIST IS ALREADY IN THE PLAYER
    bool isSame = true;
    if (audioPlayerState.playlist.value.length == tracks.length)
    {
      for (int i = 0; i < tracks.length; i++)
      {
        if (audioPlayerState.playlist.value[i].dbTrack.id != tracks[i].id)
        {
          isSame = false;
          break;
        }
      }
    }
    else
    {
      isSame = false;
    }

    if (!isSame)
    {
      Overlay.of(context).insert(_playlistLoadOverlay);
      final DateTime targetTime = DateTime.now().add(_waitTimeForAudioPlayer);
      while (DateTime.now().isBefore(targetTime) && !audioPlayerState.initialized)
      {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        print("WAITING....");
      }

      await audioPlayerState.setPlaylist(playlistFromDB: tracks);
      await audioPlayerState.shuffle(true);
    }
  }


  void databaseTestFinished(final bool success)
  {
    appdb.getAllTracks().then((final List<TableTrack> tracks) {
      final List<MutableTrack> allTracks = <MutableTrack>[];
      final List<MutableTrack> favoriteTracks = <MutableTrack>[];
      for (final TableTrack track in tracks)
      {
        allTracks.add(MutableTrack.fromTableTrack(track));
        if (track.isFavorite)
        {
          favoriteTracks.add(MutableTrack.fromTableTrack(track));
        }
      }

      allPlaylistTracks.value = allTracks;
      favoritePlaylistTracks.value = favoriteTracks;
    });
    showSnackbarMessage(message: "Database check performed with result: $success");
  }

  void selectTrack({required final MutableTrack track})
  {
    audioPlayerState.selectTrack(track);
  }


  void showSnackbarMessage({required final String message, final int seconds = 1})
  {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: Duration(seconds: seconds),));
  }

  @override
  Widget build(final BuildContext context)
  {
    return Scaffold(
      bottomNavigationBar: ValueListenableBuilder<NavigationState>(
        valueListenable: _selectedNavigation,
        builder: (final BuildContext context, final NavigationState selectedNav, final Widget? child) {
          return NavigationBar(
            onDestinationSelected: (final int index) {
              _selectedNavigation.value = _navigationStateMap[index] ?? NavigationState.player;
            },
            selectedIndex: _navigationStateMapReverse[selectedNav] ?? 0,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            height: 50,
            destinations: _navigationDestinations,
          );
        },
      ),
      body: Center(
        child: ValueListenableBuilder<NavigationState>(
          valueListenable: _selectedNavigation,
          builder: (final BuildContext context, final NavigationState selectedNav, final Widget? child)
          {
            switch(selectedNav)
            {
              case NavigationState.player:
                return PlayerPage(audioPlayerState: audioPlayerState, imageData: imageData, currentTrack: currentTrack, toggleFavorite: toggleFavorite, playlistType: playlistType,);
              case NavigationState.browser:
                return PlaylistPage(allPlaylistTracks: allPlaylistTracks, favoritePlaylistTracks: favoritePlaylistTracks, playlistType: playlistType, currentTrack: currentTrack, selectTrack: selectTrack,);
              case NavigationState.settings:
                return SettingsPage(db: appdb, errorCallback: showSnackbarMessage, allPlaylistTracks: allPlaylistTracks, favoritePlaylistTracks: favoritePlaylistTracks,);
              case NavigationState.system:
                return const SystemPage();
            }
          },
        ),
      ),
    );
  }
}

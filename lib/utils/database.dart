import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';


//AFTER UPDATE, RUN "dart run build_runner build"

class MutableTrack
{
  final int id;
  final int baseFolderId;
  final String path;
  final String title;
  final String album;
  final String artist;
  final String albumArtist;
  final int pubYear;
  final int duration;
  bool isFavorite = false;

  MutableTrack.fromTableTrack(final TableTrack track) : id = track.id, baseFolderId = track.baseFolderId, path = track.path, title = track.title, album = track.album, artist = track.artist, albumArtist = track.albumArtist, pubYear = track.pubYear, duration = track.duration, isFavorite = track.isFavorite;
  MutableTrack.fromTableTracksCompanion(final TableTracksCompanion track) : id = 0, baseFolderId = track.baseFolderId.value, path = track.path.value, title = track.title.value, album = track.album.value, artist = track.artist.value, albumArtist = track.albumArtist.value, pubYear = track.pubYear.value, duration = track.duration.value, isFavorite = track.isFavorite.value;

}


class TableBaseFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().unique()();
}

class TableTracks extends Table
{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get baseFolderId => integer().references(TableBaseFolders, #id)();
  TextColumn get path => text().unique()();
  TextColumn get title => text()();
  TextColumn get album => text()();
  TextColumn get artist => text()();
  TextColumn get albumArtist => text()();
  IntColumn get pubYear => integer()();
  IntColumn get duration => integer()();
  BoolColumn get isFavorite => boolean()();
}

class TablePlaylists extends Table
{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().unique()();
}

class TablePlaylistTracks extends Table
{
  IntColumn get playlistId => integer().references(TablePlaylists, #id)();
  IntColumn get trackId => integer().references(TableTracks, #id)();
  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{playlistId, trackId};
}


@DriftDatabase(tables: <Type>[TableBaseFolders, TableTracks, TablePlaylists, TablePlaylistTracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase([final QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;


  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'kplay_db4',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),

    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        beforeOpen: (final OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
    );
  }

  final String dbAllName = "all";

  Future<bool> databaseCheck() async
  {
    bool success = false;
    try
    {
      final List<TablePlaylist> playLists = await select(tablePlaylists).get();
      if (!playLists.any((final TablePlaylist playlist) => playlist.title == dbAllName))
      {
        await into(tablePlaylists).insert(TablePlaylistsCompanion.insert(title: dbAllName));
      }

      success = true;
    }
    catch (_)
    {}
    return success;
  }

  Future<TablePlaylist?> getAllPlaylist() async
  {
    return (select(tablePlaylists)..where((final $TablePlaylistsTable table) => table.title.equals(dbAllName))).getSingleOrNull();
  }


  Future<bool> insertTracks({required final List<TableTracksCompanion> tracks}) async
  {
    bool success = true;

    final List<TableTrack> existingTracks = await select(tableTracks).get();
    final List<String> existingTrackPaths = existingTracks.map((final TableTrack track) => track.path).toList();
    final List<String> newTrackPaths = tracks.map((final TableTracksCompanion track) => track.path.value).toList();
    final List<TableTrack> tracksToRemove = existingTracks.where((final TableTrack existingTrack) => !newTrackPaths.contains(existingTrack.path)).toList();

    try
    {
      if (tracksToRemove.isNotEmpty)
      {
        await transaction(() async {
          for (final TableTrack trackToRemove in tracksToRemove)
          {
            await (delete(tablePlaylistTracks)..where((final $TablePlaylistTracksTable table) => table.trackId.equals(trackToRemove.id))).go();
            await (delete(tableTracks)..where((final $TableTracksTable tableTracks) => tableTracks.id.equals(trackToRemove.id))).go();
          }
        });

      }

      final List<TableTracksCompanion> tracksToUpdate = <TableTracksCompanion>[];
      final List<TableTracksCompanion> tracksToInsert = <TableTracksCompanion>[];

      for (final TableTracksCompanion track in tracks)
      {
        if (existingTrackPaths.contains(track.path.value))
        {
          tracksToUpdate.add(track);
        }
        else
        {
          tracksToInsert.add(track);
        }
      }

      // Insert new tracks in a batch
      await batch((final Batch batch) {
        batch.insertAll(tableTracks, tracksToInsert, mode: InsertMode.insert);
      });

      //SELECT ALL NEWLY INSERTED TRACKS
      final List<TableTrack> newTracks = await (select(tableTracks)..where((final $TableTracksTable tableTracks) => tableTracks.path.isIn(tracksToInsert.map((final TableTracksCompanion track) => track.path.value)))).get();

      //Insert new tracks into all playlist
      final TablePlaylist? allPlaylist = await getAllPlaylist();
      if (allPlaylist != null)
      {
        final List<TablePlaylistTracksCompanion> playlistTracks = <TablePlaylistTracksCompanion>[];
        for (final TableTrack track in newTracks)
        {
          playlistTracks.add(TablePlaylistTracksCompanion.insert(playlistId: allPlaylist.id, trackId: track.id));
        }
        await batch((final Batch batch) {
          batch.insertAll(tablePlaylistTracks, playlistTracks, mode: InsertMode.insert);
        });
      }

      // Update existing tracks in a batch
      await batch((final Batch batch) {
        for (final TableTracksCompanion trackToUpdate in tracksToUpdate) {
          batch.update(tableTracks, trackToUpdate, where: (final $TableTracksTable table) => table.path.equals(trackToUpdate.path.value));
        }
      });
    }
    catch (_)
    {
      success = false;
    }

    return success;
  }

  Future<TableTrack?> toggleFavorite(final int trackId, final bool currentFavoriteValue) async
  {
    final int affectedRows = await (update(tableTracks)..where((final $TableTracksTable table) => table.id.equals(trackId))).write(TableTracksCompanion(isFavorite: Value<bool>(!currentFavoriteValue)));
    if (affectedRows > 0)
    {
      return (select(tableTracks)..where((final $TableTracksTable table) => table.id.equals(trackId))).getSingleOrNull();
    }
    return null;
  }

  Future<List<TableTrack>> getAllTracks() async
  {
    final List<TableTrack> tracks = <TableTrack>[];
    final TablePlaylist? allPlaylist =  await getAllPlaylist();
    if (allPlaylist != null)
    {
      final JoinedSelectStatement<HasResultSet, dynamic> query = select(tablePlaylistTracks).join(<Join<HasResultSet, dynamic>>[leftOuterJoin(tableTracks, tableTracks.id.equalsExp(tablePlaylistTracks.trackId))]);
      query.where(tablePlaylistTracks.playlistId.equals(allPlaylist.id));
      query.orderBy(<OrderingTerm>[OrderingTerm.asc(tableTracks.album), OrderingTerm.asc(tableTracks.title)]);
      final List<TypedResult> playlistTracks = await query.get();
      for (final TypedResult typedResult in playlistTracks)
      {
        tracks.add(typedResult.readTable(tableTracks));
      }

    }
    return tracks;
  }

  Future<List<TableTrack>> getFavoriteTracks() async
  {
    final List<TableTrack> tracks = <TableTrack>[];
    final TablePlaylist? allPlaylist =  await getAllPlaylist();
    if (allPlaylist != null)
    {
      final JoinedSelectStatement<HasResultSet, dynamic> query = select(tablePlaylistTracks).join(<Join<HasResultSet, dynamic>>[leftOuterJoin(tableTracks, tableTracks.id.equalsExp(tablePlaylistTracks.trackId))]);
      query.where(tablePlaylistTracks.playlistId.equals(allPlaylist.id) & tableTracks.isFavorite.equals(true));
      query.orderBy(<OrderingTerm>[OrderingTerm.asc(tableTracks.album), OrderingTerm.asc(tableTracks.title)]);
      final List<TypedResult> playlistTracks = await query.get();
      for (final TypedResult typedResult in playlistTracks)
      {
        tracks.add(typedResult.readTable(tableTracks));
      }

    }
    return tracks;
  }


  Future<bool> insertBaseFolder(final String path) async
  {
    bool success = false;

    //TODO check that the path is not inside another one (or vice versa)

    try
    {
      final int insertedRows = await into(tableBaseFolders).insert(TableBaseFoldersCompanion.insert(title: path));
      success = insertedRows > 0;
    }
    catch (_)
    {}
    return success;

  }

  Future<bool> deleteBaseFolder(final TableBaseFolder folder) async
  {
    bool success = false;
    try
    {
      //get all tracks that use this base folder
      final List<TableTrack> tracksWithBaseFolder = await (select(tableTracks)..where((final $TableTracksTable tbl) => tbl.baseFolderId.equals(folder.id))).get();
      //delete all playlist entries that use these tracks
      await (delete(tablePlaylistTracks)..where((final $TablePlaylistTracksTable tbl) => tbl.trackId.isIn(tracksWithBaseFolder.map((final TableTrack track) => track.id)))).go();
      //delete all tracks that use this base folder
      await (delete(tableTracks)..where((final $TableTracksTable tbl) => tbl.baseFolderId.equals(folder.id))).go();
      //delete the base folder
      final int deletedFolderEntries = await (delete(tableBaseFolders)..where((final $TableBaseFoldersTable tableBaseFolders) => tableBaseFolders.id.equals(folder.id))).go();
      success = deletedFolderEntries > 0;
    }
    catch (_){}
    return success;
  }

}

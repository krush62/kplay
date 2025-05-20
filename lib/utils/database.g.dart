// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TableBaseFoldersTable extends TableBaseFolders
    with TableInfo<$TableBaseFoldersTable, TableBaseFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableBaseFoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_base_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableBaseFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableBaseFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableBaseFolder(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
    );
  }

  @override
  $TableBaseFoldersTable createAlias(String alias) {
    return $TableBaseFoldersTable(attachedDatabase, alias);
  }
}

class TableBaseFolder extends DataClass implements Insertable<TableBaseFolder> {
  final int id;
  final String title;
  const TableBaseFolder({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  TableBaseFoldersCompanion toCompanion(bool nullToAbsent) {
    return TableBaseFoldersCompanion(id: Value(id), title: Value(title));
  }

  factory TableBaseFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableBaseFolder(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  TableBaseFolder copyWith({int? id, String? title}) =>
      TableBaseFolder(id: id ?? this.id, title: title ?? this.title);
  TableBaseFolder copyWithCompanion(TableBaseFoldersCompanion data) {
    return TableBaseFolder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableBaseFolder(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableBaseFolder &&
          other.id == this.id &&
          other.title == this.title);
}

class TableBaseFoldersCompanion extends UpdateCompanion<TableBaseFolder> {
  final Value<int> id;
  final Value<String> title;
  const TableBaseFoldersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  TableBaseFoldersCompanion.insert({
    this.id = const Value.absent(),
    required String title,
  }) : title = Value(title);
  static Insertable<TableBaseFolder> custom({
    Expression<int>? id,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  TableBaseFoldersCompanion copyWith({Value<int>? id, Value<String>? title}) {
    return TableBaseFoldersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableBaseFoldersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $TableTracksTable extends TableTracks
    with TableInfo<$TableTracksTable, TableTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _baseFolderIdMeta = const VerificationMeta(
    'baseFolderId',
  );
  @override
  late final GeneratedColumn<int> baseFolderId = GeneratedColumn<int>(
    'base_folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES table_base_folders (id)',
    ),
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _albumArtistMeta = const VerificationMeta(
    'albumArtist',
  );
  @override
  late final GeneratedColumn<String> albumArtist = GeneratedColumn<String>(
    'album_artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pubYearMeta = const VerificationMeta(
    'pubYear',
  );
  @override
  late final GeneratedColumn<int> pubYear = GeneratedColumn<int>(
    'pub_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseFolderId,
    path,
    title,
    album,
    artist,
    albumArtist,
    pubYear,
    duration,
    isFavorite,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_folder_id')) {
      context.handle(
        _baseFolderIdMeta,
        baseFolderId.isAcceptableOrUnknown(
          data['base_folder_id']!,
          _baseFolderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseFolderIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('album')) {
      context.handle(
        _albumMeta,
        album.isAcceptableOrUnknown(data['album']!, _albumMeta),
      );
    } else if (isInserting) {
      context.missing(_albumMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    } else if (isInserting) {
      context.missing(_artistMeta);
    }
    if (data.containsKey('album_artist')) {
      context.handle(
        _albumArtistMeta,
        albumArtist.isAcceptableOrUnknown(
          data['album_artist']!,
          _albumArtistMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_albumArtistMeta);
    }
    if (data.containsKey('pub_year')) {
      context.handle(
        _pubYearMeta,
        pubYear.isAcceptableOrUnknown(data['pub_year']!, _pubYearMeta),
      );
    } else if (isInserting) {
      context.missing(_pubYearMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    } else if (isInserting) {
      context.missing(_isFavoriteMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TableTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableTrack(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      baseFolderId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}base_folder_id'],
          )!,
      path:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}path'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      album:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}album'],
          )!,
      artist:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}artist'],
          )!,
      albumArtist:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}album_artist'],
          )!,
      pubYear:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pub_year'],
          )!,
      duration:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration'],
          )!,
      isFavorite:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_favorite'],
          )!,
    );
  }

  @override
  $TableTracksTable createAlias(String alias) {
    return $TableTracksTable(attachedDatabase, alias);
  }
}

class TableTrack extends DataClass implements Insertable<TableTrack> {
  final int id;
  final int baseFolderId;
  final String path;
  final String title;
  final String album;
  final String artist;
  final String albumArtist;
  final int pubYear;
  final int duration;
  final bool isFavorite;
  const TableTrack({
    required this.id,
    required this.baseFolderId,
    required this.path,
    required this.title,
    required this.album,
    required this.artist,
    required this.albumArtist,
    required this.pubYear,
    required this.duration,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_folder_id'] = Variable<int>(baseFolderId);
    map['path'] = Variable<String>(path);
    map['title'] = Variable<String>(title);
    map['album'] = Variable<String>(album);
    map['artist'] = Variable<String>(artist);
    map['album_artist'] = Variable<String>(albumArtist);
    map['pub_year'] = Variable<int>(pubYear);
    map['duration'] = Variable<int>(duration);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  TableTracksCompanion toCompanion(bool nullToAbsent) {
    return TableTracksCompanion(
      id: Value(id),
      baseFolderId: Value(baseFolderId),
      path: Value(path),
      title: Value(title),
      album: Value(album),
      artist: Value(artist),
      albumArtist: Value(albumArtist),
      pubYear: Value(pubYear),
      duration: Value(duration),
      isFavorite: Value(isFavorite),
    );
  }

  factory TableTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableTrack(
      id: serializer.fromJson<int>(json['id']),
      baseFolderId: serializer.fromJson<int>(json['baseFolderId']),
      path: serializer.fromJson<String>(json['path']),
      title: serializer.fromJson<String>(json['title']),
      album: serializer.fromJson<String>(json['album']),
      artist: serializer.fromJson<String>(json['artist']),
      albumArtist: serializer.fromJson<String>(json['albumArtist']),
      pubYear: serializer.fromJson<int>(json['pubYear']),
      duration: serializer.fromJson<int>(json['duration']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseFolderId': serializer.toJson<int>(baseFolderId),
      'path': serializer.toJson<String>(path),
      'title': serializer.toJson<String>(title),
      'album': serializer.toJson<String>(album),
      'artist': serializer.toJson<String>(artist),
      'albumArtist': serializer.toJson<String>(albumArtist),
      'pubYear': serializer.toJson<int>(pubYear),
      'duration': serializer.toJson<int>(duration),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  TableTrack copyWith({
    int? id,
    int? baseFolderId,
    String? path,
    String? title,
    String? album,
    String? artist,
    String? albumArtist,
    int? pubYear,
    int? duration,
    bool? isFavorite,
  }) => TableTrack(
    id: id ?? this.id,
    baseFolderId: baseFolderId ?? this.baseFolderId,
    path: path ?? this.path,
    title: title ?? this.title,
    album: album ?? this.album,
    artist: artist ?? this.artist,
    albumArtist: albumArtist ?? this.albumArtist,
    pubYear: pubYear ?? this.pubYear,
    duration: duration ?? this.duration,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  TableTrack copyWithCompanion(TableTracksCompanion data) {
    return TableTrack(
      id: data.id.present ? data.id.value : this.id,
      baseFolderId:
          data.baseFolderId.present
              ? data.baseFolderId.value
              : this.baseFolderId,
      path: data.path.present ? data.path.value : this.path,
      title: data.title.present ? data.title.value : this.title,
      album: data.album.present ? data.album.value : this.album,
      artist: data.artist.present ? data.artist.value : this.artist,
      albumArtist:
          data.albumArtist.present ? data.albumArtist.value : this.albumArtist,
      pubYear: data.pubYear.present ? data.pubYear.value : this.pubYear,
      duration: data.duration.present ? data.duration.value : this.duration,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableTrack(')
          ..write('id: $id, ')
          ..write('baseFolderId: $baseFolderId, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('album: $album, ')
          ..write('artist: $artist, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('pubYear: $pubYear, ')
          ..write('duration: $duration, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseFolderId,
    path,
    title,
    album,
    artist,
    albumArtist,
    pubYear,
    duration,
    isFavorite,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableTrack &&
          other.id == this.id &&
          other.baseFolderId == this.baseFolderId &&
          other.path == this.path &&
          other.title == this.title &&
          other.album == this.album &&
          other.artist == this.artist &&
          other.albumArtist == this.albumArtist &&
          other.pubYear == this.pubYear &&
          other.duration == this.duration &&
          other.isFavorite == this.isFavorite);
}

class TableTracksCompanion extends UpdateCompanion<TableTrack> {
  final Value<int> id;
  final Value<int> baseFolderId;
  final Value<String> path;
  final Value<String> title;
  final Value<String> album;
  final Value<String> artist;
  final Value<String> albumArtist;
  final Value<int> pubYear;
  final Value<int> duration;
  final Value<bool> isFavorite;
  const TableTracksCompanion({
    this.id = const Value.absent(),
    this.baseFolderId = const Value.absent(),
    this.path = const Value.absent(),
    this.title = const Value.absent(),
    this.album = const Value.absent(),
    this.artist = const Value.absent(),
    this.albumArtist = const Value.absent(),
    this.pubYear = const Value.absent(),
    this.duration = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  TableTracksCompanion.insert({
    this.id = const Value.absent(),
    required int baseFolderId,
    required String path,
    required String title,
    required String album,
    required String artist,
    required String albumArtist,
    required int pubYear,
    required int duration,
    required bool isFavorite,
  }) : baseFolderId = Value(baseFolderId),
       path = Value(path),
       title = Value(title),
       album = Value(album),
       artist = Value(artist),
       albumArtist = Value(albumArtist),
       pubYear = Value(pubYear),
       duration = Value(duration),
       isFavorite = Value(isFavorite);
  static Insertable<TableTrack> custom({
    Expression<int>? id,
    Expression<int>? baseFolderId,
    Expression<String>? path,
    Expression<String>? title,
    Expression<String>? album,
    Expression<String>? artist,
    Expression<String>? albumArtist,
    Expression<int>? pubYear,
    Expression<int>? duration,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseFolderId != null) 'base_folder_id': baseFolderId,
      if (path != null) 'path': path,
      if (title != null) 'title': title,
      if (album != null) 'album': album,
      if (artist != null) 'artist': artist,
      if (albumArtist != null) 'album_artist': albumArtist,
      if (pubYear != null) 'pub_year': pubYear,
      if (duration != null) 'duration': duration,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  TableTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? baseFolderId,
    Value<String>? path,
    Value<String>? title,
    Value<String>? album,
    Value<String>? artist,
    Value<String>? albumArtist,
    Value<int>? pubYear,
    Value<int>? duration,
    Value<bool>? isFavorite,
  }) {
    return TableTracksCompanion(
      id: id ?? this.id,
      baseFolderId: baseFolderId ?? this.baseFolderId,
      path: path ?? this.path,
      title: title ?? this.title,
      album: album ?? this.album,
      artist: artist ?? this.artist,
      albumArtist: albumArtist ?? this.albumArtist,
      pubYear: pubYear ?? this.pubYear,
      duration: duration ?? this.duration,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseFolderId.present) {
      map['base_folder_id'] = Variable<int>(baseFolderId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (albumArtist.present) {
      map['album_artist'] = Variable<String>(albumArtist.value);
    }
    if (pubYear.present) {
      map['pub_year'] = Variable<int>(pubYear.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableTracksCompanion(')
          ..write('id: $id, ')
          ..write('baseFolderId: $baseFolderId, ')
          ..write('path: $path, ')
          ..write('title: $title, ')
          ..write('album: $album, ')
          ..write('artist: $artist, ')
          ..write('albumArtist: $albumArtist, ')
          ..write('pubYear: $pubYear, ')
          ..write('duration: $duration, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $TablePlaylistsTable extends TablePlaylists
    with TableInfo<$TablePlaylistsTable, TablePlaylist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablePlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablePlaylist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TablePlaylist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablePlaylist(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
    );
  }

  @override
  $TablePlaylistsTable createAlias(String alias) {
    return $TablePlaylistsTable(attachedDatabase, alias);
  }
}

class TablePlaylist extends DataClass implements Insertable<TablePlaylist> {
  final int id;
  final String title;
  const TablePlaylist({required this.id, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    return map;
  }

  TablePlaylistsCompanion toCompanion(bool nullToAbsent) {
    return TablePlaylistsCompanion(id: Value(id), title: Value(title));
  }

  factory TablePlaylist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablePlaylist(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
    };
  }

  TablePlaylist copyWith({int? id, String? title}) =>
      TablePlaylist(id: id ?? this.id, title: title ?? this.title);
  TablePlaylist copyWithCompanion(TablePlaylistsCompanion data) {
    return TablePlaylist(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablePlaylist(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablePlaylist &&
          other.id == this.id &&
          other.title == this.title);
}

class TablePlaylistsCompanion extends UpdateCompanion<TablePlaylist> {
  final Value<int> id;
  final Value<String> title;
  const TablePlaylistsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
  });
  TablePlaylistsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
  }) : title = Value(title);
  static Insertable<TablePlaylist> custom({
    Expression<int>? id,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
    });
  }

  TablePlaylistsCompanion copyWith({Value<int>? id, Value<String>? title}) {
    return TablePlaylistsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablePlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $TablePlaylistTracksTable extends TablePlaylistTracks
    with TableInfo<$TablePlaylistTracksTable, TablePlaylistTrack> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablePlaylistTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES table_playlists (id)',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES table_tracks (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [playlistId, trackId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_playlist_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablePlaylistTrack> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {playlistId, trackId};
  @override
  TablePlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablePlaylistTrack(
      playlistId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}playlist_id'],
          )!,
      trackId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}track_id'],
          )!,
    );
  }

  @override
  $TablePlaylistTracksTable createAlias(String alias) {
    return $TablePlaylistTracksTable(attachedDatabase, alias);
  }
}

class TablePlaylistTrack extends DataClass
    implements Insertable<TablePlaylistTrack> {
  final int playlistId;
  final int trackId;
  const TablePlaylistTrack({required this.playlistId, required this.trackId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['playlist_id'] = Variable<int>(playlistId);
    map['track_id'] = Variable<int>(trackId);
    return map;
  }

  TablePlaylistTracksCompanion toCompanion(bool nullToAbsent) {
    return TablePlaylistTracksCompanion(
      playlistId: Value(playlistId),
      trackId: Value(trackId),
    );
  }

  factory TablePlaylistTrack.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablePlaylistTrack(
      playlistId: serializer.fromJson<int>(json['playlistId']),
      trackId: serializer.fromJson<int>(json['trackId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'playlistId': serializer.toJson<int>(playlistId),
      'trackId': serializer.toJson<int>(trackId),
    };
  }

  TablePlaylistTrack copyWith({int? playlistId, int? trackId}) =>
      TablePlaylistTrack(
        playlistId: playlistId ?? this.playlistId,
        trackId: trackId ?? this.trackId,
      );
  TablePlaylistTrack copyWithCompanion(TablePlaylistTracksCompanion data) {
    return TablePlaylistTrack(
      playlistId:
          data.playlistId.present ? data.playlistId.value : this.playlistId,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablePlaylistTrack(')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(playlistId, trackId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablePlaylistTrack &&
          other.playlistId == this.playlistId &&
          other.trackId == this.trackId);
}

class TablePlaylistTracksCompanion extends UpdateCompanion<TablePlaylistTrack> {
  final Value<int> playlistId;
  final Value<int> trackId;
  final Value<int> rowid;
  const TablePlaylistTracksCompanion({
    this.playlistId = const Value.absent(),
    this.trackId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TablePlaylistTracksCompanion.insert({
    required int playlistId,
    required int trackId,
    this.rowid = const Value.absent(),
  }) : playlistId = Value(playlistId),
       trackId = Value(trackId);
  static Insertable<TablePlaylistTrack> custom({
    Expression<int>? playlistId,
    Expression<int>? trackId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (playlistId != null) 'playlist_id': playlistId,
      if (trackId != null) 'track_id': trackId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TablePlaylistTracksCompanion copyWith({
    Value<int>? playlistId,
    Value<int>? trackId,
    Value<int>? rowid,
  }) {
    return TablePlaylistTracksCompanion(
      playlistId: playlistId ?? this.playlistId,
      trackId: trackId ?? this.trackId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (playlistId.present) {
      map['playlist_id'] = Variable<int>(playlistId.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablePlaylistTracksCompanion(')
          ..write('playlistId: $playlistId, ')
          ..write('trackId: $trackId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TableBaseFoldersTable tableBaseFolders = $TableBaseFoldersTable(
    this,
  );
  late final $TableTracksTable tableTracks = $TableTracksTable(this);
  late final $TablePlaylistsTable tablePlaylists = $TablePlaylistsTable(this);
  late final $TablePlaylistTracksTable tablePlaylistTracks =
      $TablePlaylistTracksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tableBaseFolders,
    tableTracks,
    tablePlaylists,
    tablePlaylistTracks,
  ];
}

typedef $$TableBaseFoldersTableCreateCompanionBuilder =
    TableBaseFoldersCompanion Function({Value<int> id, required String title});
typedef $$TableBaseFoldersTableUpdateCompanionBuilder =
    TableBaseFoldersCompanion Function({Value<int> id, Value<String> title});

final class $$TableBaseFoldersTableReferences
    extends
        BaseReferences<_$AppDatabase, $TableBaseFoldersTable, TableBaseFolder> {
  $$TableBaseFoldersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TableTracksTable, List<TableTrack>>
  _tableTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tableTracks,
    aliasName: $_aliasNameGenerator(
      db.tableBaseFolders.id,
      db.tableTracks.baseFolderId,
    ),
  );

  $$TableTracksTableProcessedTableManager get tableTracksRefs {
    final manager = $$TableTracksTableTableManager(
      $_db,
      $_db.tableTracks,
    ).filter((f) => f.baseFolderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tableTracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TableBaseFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $TableBaseFoldersTable> {
  $$TableBaseFoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tableTracksRefs(
    Expression<bool> Function($$TableTracksTableFilterComposer f) f,
  ) {
    final $$TableTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tableTracks,
      getReferencedColumn: (t) => t.baseFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableTracksTableFilterComposer(
            $db: $db,
            $table: $db.tableTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TableBaseFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $TableBaseFoldersTable> {
  $$TableBaseFoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TableBaseFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableBaseFoldersTable> {
  $$TableBaseFoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> tableTracksRefs<T extends Object>(
    Expression<T> Function($$TableTracksTableAnnotationComposer a) f,
  ) {
    final $$TableTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tableTracks,
      getReferencedColumn: (t) => t.baseFolderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tableTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TableBaseFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableBaseFoldersTable,
          TableBaseFolder,
          $$TableBaseFoldersTableFilterComposer,
          $$TableBaseFoldersTableOrderingComposer,
          $$TableBaseFoldersTableAnnotationComposer,
          $$TableBaseFoldersTableCreateCompanionBuilder,
          $$TableBaseFoldersTableUpdateCompanionBuilder,
          (TableBaseFolder, $$TableBaseFoldersTableReferences),
          TableBaseFolder,
          PrefetchHooks Function({bool tableTracksRefs})
        > {
  $$TableBaseFoldersTableTableManager(
    _$AppDatabase db,
    $TableBaseFoldersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$TableBaseFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TableBaseFoldersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TableBaseFoldersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => TableBaseFoldersCompanion(id: id, title: title),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String title}) =>
                  TableBaseFoldersCompanion.insert(id: id, title: title),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TableBaseFoldersTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({tableTracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tableTracksRefs) db.tableTracks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tableTracksRefs)
                    await $_getPrefetchedData<
                      TableBaseFolder,
                      $TableBaseFoldersTable,
                      TableTrack
                    >(
                      currentTable: table,
                      referencedTable: $$TableBaseFoldersTableReferences
                          ._tableTracksRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TableBaseFoldersTableReferences(
                                db,
                                table,
                                p0,
                              ).tableTracksRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.baseFolderId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TableBaseFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableBaseFoldersTable,
      TableBaseFolder,
      $$TableBaseFoldersTableFilterComposer,
      $$TableBaseFoldersTableOrderingComposer,
      $$TableBaseFoldersTableAnnotationComposer,
      $$TableBaseFoldersTableCreateCompanionBuilder,
      $$TableBaseFoldersTableUpdateCompanionBuilder,
      (TableBaseFolder, $$TableBaseFoldersTableReferences),
      TableBaseFolder,
      PrefetchHooks Function({bool tableTracksRefs})
    >;
typedef $$TableTracksTableCreateCompanionBuilder =
    TableTracksCompanion Function({
      Value<int> id,
      required int baseFolderId,
      required String path,
      required String title,
      required String album,
      required String artist,
      required String albumArtist,
      required int pubYear,
      required int duration,
      required bool isFavorite,
    });
typedef $$TableTracksTableUpdateCompanionBuilder =
    TableTracksCompanion Function({
      Value<int> id,
      Value<int> baseFolderId,
      Value<String> path,
      Value<String> title,
      Value<String> album,
      Value<String> artist,
      Value<String> albumArtist,
      Value<int> pubYear,
      Value<int> duration,
      Value<bool> isFavorite,
    });

final class $$TableTracksTableReferences
    extends BaseReferences<_$AppDatabase, $TableTracksTable, TableTrack> {
  $$TableTracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TableBaseFoldersTable _baseFolderIdTable(_$AppDatabase db) =>
      db.tableBaseFolders.createAlias(
        $_aliasNameGenerator(
          db.tableTracks.baseFolderId,
          db.tableBaseFolders.id,
        ),
      );

  $$TableBaseFoldersTableProcessedTableManager get baseFolderId {
    final $_column = $_itemColumn<int>('base_folder_id')!;

    final manager = $$TableBaseFoldersTableTableManager(
      $_db,
      $_db.tableBaseFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseFolderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TablePlaylistTracksTable,
    List<TablePlaylistTrack>
  >
  _tablePlaylistTracksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tablePlaylistTracks,
        aliasName: $_aliasNameGenerator(
          db.tableTracks.id,
          db.tablePlaylistTracks.trackId,
        ),
      );

  $$TablePlaylistTracksTableProcessedTableManager get tablePlaylistTracksRefs {
    final manager = $$TablePlaylistTracksTableTableManager(
      $_db,
      $_db.tablePlaylistTracks,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tablePlaylistTracksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TableTracksTableFilterComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pubYear => $composableBuilder(
    column: $table.pubYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  $$TableBaseFoldersTableFilterComposer get baseFolderId {
    final $$TableBaseFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseFolderId,
      referencedTable: $db.tableBaseFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableBaseFoldersTableFilterComposer(
            $db: $db,
            $table: $db.tableBaseFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tablePlaylistTracksRefs(
    Expression<bool> Function($$TablePlaylistTracksTableFilterComposer f) f,
  ) {
    final $$TablePlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablePlaylistTracks,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablePlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.tablePlaylistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TableTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pubYear => $composableBuilder(
    column: $table.pubYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  $$TableBaseFoldersTableOrderingComposer get baseFolderId {
    final $$TableBaseFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseFolderId,
      referencedTable: $db.tableBaseFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableBaseFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.tableBaseFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableTracksTable> {
  $$TableTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get albumArtist => $composableBuilder(
    column: $table.albumArtist,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pubYear =>
      $composableBuilder(column: $table.pubYear, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  $$TableBaseFoldersTableAnnotationComposer get baseFolderId {
    final $$TableBaseFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseFolderId,
      referencedTable: $db.tableBaseFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableBaseFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.tableBaseFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tablePlaylistTracksRefs<T extends Object>(
    Expression<T> Function($$TablePlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$TablePlaylistTracksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tablePlaylistTracks,
          getReferencedColumn: (t) => t.trackId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TablePlaylistTracksTableAnnotationComposer(
                $db: $db,
                $table: $db.tablePlaylistTracks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TableTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableTracksTable,
          TableTrack,
          $$TableTracksTableFilterComposer,
          $$TableTracksTableOrderingComposer,
          $$TableTracksTableAnnotationComposer,
          $$TableTracksTableCreateCompanionBuilder,
          $$TableTracksTableUpdateCompanionBuilder,
          (TableTrack, $$TableTracksTableReferences),
          TableTrack,
          PrefetchHooks Function({
            bool baseFolderId,
            bool tablePlaylistTracksRefs,
          })
        > {
  $$TableTracksTableTableManager(_$AppDatabase db, $TableTracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TableTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$TableTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$TableTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> baseFolderId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> album = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<String> albumArtist = const Value.absent(),
                Value<int> pubYear = const Value.absent(),
                Value<int> duration = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => TableTracksCompanion(
                id: id,
                baseFolderId: baseFolderId,
                path: path,
                title: title,
                album: album,
                artist: artist,
                albumArtist: albumArtist,
                pubYear: pubYear,
                duration: duration,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int baseFolderId,
                required String path,
                required String title,
                required String album,
                required String artist,
                required String albumArtist,
                required int pubYear,
                required int duration,
                required bool isFavorite,
              }) => TableTracksCompanion.insert(
                id: id,
                baseFolderId: baseFolderId,
                path: path,
                title: title,
                album: album,
                artist: artist,
                albumArtist: albumArtist,
                pubYear: pubYear,
                duration: duration,
                isFavorite: isFavorite,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TableTracksTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            baseFolderId = false,
            tablePlaylistTracksRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tablePlaylistTracksRefs) db.tablePlaylistTracks,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (baseFolderId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.baseFolderId,
                            referencedTable: $$TableTracksTableReferences
                                ._baseFolderIdTable(db),
                            referencedColumn:
                                $$TableTracksTableReferences
                                    ._baseFolderIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tablePlaylistTracksRefs)
                    await $_getPrefetchedData<
                      TableTrack,
                      $TableTracksTable,
                      TablePlaylistTrack
                    >(
                      currentTable: table,
                      referencedTable: $$TableTracksTableReferences
                          ._tablePlaylistTracksRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TableTracksTableReferences(
                                db,
                                table,
                                p0,
                              ).tablePlaylistTracksRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.trackId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TableTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableTracksTable,
      TableTrack,
      $$TableTracksTableFilterComposer,
      $$TableTracksTableOrderingComposer,
      $$TableTracksTableAnnotationComposer,
      $$TableTracksTableCreateCompanionBuilder,
      $$TableTracksTableUpdateCompanionBuilder,
      (TableTrack, $$TableTracksTableReferences),
      TableTrack,
      PrefetchHooks Function({bool baseFolderId, bool tablePlaylistTracksRefs})
    >;
typedef $$TablePlaylistsTableCreateCompanionBuilder =
    TablePlaylistsCompanion Function({Value<int> id, required String title});
typedef $$TablePlaylistsTableUpdateCompanionBuilder =
    TablePlaylistsCompanion Function({Value<int> id, Value<String> title});

final class $$TablePlaylistsTableReferences
    extends BaseReferences<_$AppDatabase, $TablePlaylistsTable, TablePlaylist> {
  $$TablePlaylistsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TablePlaylistTracksTable,
    List<TablePlaylistTrack>
  >
  _tablePlaylistTracksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tablePlaylistTracks,
        aliasName: $_aliasNameGenerator(
          db.tablePlaylists.id,
          db.tablePlaylistTracks.playlistId,
        ),
      );

  $$TablePlaylistTracksTableProcessedTableManager get tablePlaylistTracksRefs {
    final manager = $$TablePlaylistTracksTableTableManager(
      $_db,
      $_db.tablePlaylistTracks,
    ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tablePlaylistTracksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TablePlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $TablePlaylistsTable> {
  $$TablePlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tablePlaylistTracksRefs(
    Expression<bool> Function($$TablePlaylistTracksTableFilterComposer f) f,
  ) {
    final $$TablePlaylistTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablePlaylistTracks,
      getReferencedColumn: (t) => t.playlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablePlaylistTracksTableFilterComposer(
            $db: $db,
            $table: $db.tablePlaylistTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TablePlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $TablePlaylistsTable> {
  $$TablePlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TablePlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablePlaylistsTable> {
  $$TablePlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> tablePlaylistTracksRefs<T extends Object>(
    Expression<T> Function($$TablePlaylistTracksTableAnnotationComposer a) f,
  ) {
    final $$TablePlaylistTracksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tablePlaylistTracks,
          getReferencedColumn: (t) => t.playlistId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TablePlaylistTracksTableAnnotationComposer(
                $db: $db,
                $table: $db.tablePlaylistTracks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TablePlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablePlaylistsTable,
          TablePlaylist,
          $$TablePlaylistsTableFilterComposer,
          $$TablePlaylistsTableOrderingComposer,
          $$TablePlaylistsTableAnnotationComposer,
          $$TablePlaylistsTableCreateCompanionBuilder,
          $$TablePlaylistsTableUpdateCompanionBuilder,
          (TablePlaylist, $$TablePlaylistsTableReferences),
          TablePlaylist,
          PrefetchHooks Function({bool tablePlaylistTracksRefs})
        > {
  $$TablePlaylistsTableTableManager(
    _$AppDatabase db,
    $TablePlaylistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TablePlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$TablePlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$TablePlaylistsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
              }) => TablePlaylistsCompanion(id: id, title: title),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String title}) =>
                  TablePlaylistsCompanion.insert(id: id, title: title),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TablePlaylistsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({tablePlaylistTracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (tablePlaylistTracksRefs) db.tablePlaylistTracks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tablePlaylistTracksRefs)
                    await $_getPrefetchedData<
                      TablePlaylist,
                      $TablePlaylistsTable,
                      TablePlaylistTrack
                    >(
                      currentTable: table,
                      referencedTable: $$TablePlaylistsTableReferences
                          ._tablePlaylistTracksRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$TablePlaylistsTableReferences(
                                db,
                                table,
                                p0,
                              ).tablePlaylistTracksRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.playlistId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TablePlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablePlaylistsTable,
      TablePlaylist,
      $$TablePlaylistsTableFilterComposer,
      $$TablePlaylistsTableOrderingComposer,
      $$TablePlaylistsTableAnnotationComposer,
      $$TablePlaylistsTableCreateCompanionBuilder,
      $$TablePlaylistsTableUpdateCompanionBuilder,
      (TablePlaylist, $$TablePlaylistsTableReferences),
      TablePlaylist,
      PrefetchHooks Function({bool tablePlaylistTracksRefs})
    >;
typedef $$TablePlaylistTracksTableCreateCompanionBuilder =
    TablePlaylistTracksCompanion Function({
      required int playlistId,
      required int trackId,
      Value<int> rowid,
    });
typedef $$TablePlaylistTracksTableUpdateCompanionBuilder =
    TablePlaylistTracksCompanion Function({
      Value<int> playlistId,
      Value<int> trackId,
      Value<int> rowid,
    });

final class $$TablePlaylistTracksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TablePlaylistTracksTable,
          TablePlaylistTrack
        > {
  $$TablePlaylistTracksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TablePlaylistsTable _playlistIdTable(_$AppDatabase db) =>
      db.tablePlaylists.createAlias(
        $_aliasNameGenerator(
          db.tablePlaylistTracks.playlistId,
          db.tablePlaylists.id,
        ),
      );

  $$TablePlaylistsTableProcessedTableManager get playlistId {
    final $_column = $_itemColumn<int>('playlist_id')!;

    final manager = $$TablePlaylistsTableTableManager(
      $_db,
      $_db.tablePlaylists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TableTracksTable _trackIdTable(_$AppDatabase db) =>
      db.tableTracks.createAlias(
        $_aliasNameGenerator(db.tablePlaylistTracks.trackId, db.tableTracks.id),
      );

  $$TableTracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<int>('track_id')!;

    final manager = $$TableTracksTableTableManager(
      $_db,
      $_db.tableTracks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TablePlaylistTracksTableFilterComposer
    extends Composer<_$AppDatabase, $TablePlaylistTracksTable> {
  $$TablePlaylistTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TablePlaylistsTableFilterComposer get playlistId {
    final $$TablePlaylistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.tablePlaylists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablePlaylistsTableFilterComposer(
            $db: $db,
            $table: $db.tablePlaylists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TableTracksTableFilterComposer get trackId {
    final $$TableTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tableTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableTracksTableFilterComposer(
            $db: $db,
            $table: $db.tableTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablePlaylistTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $TablePlaylistTracksTable> {
  $$TablePlaylistTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TablePlaylistsTableOrderingComposer get playlistId {
    final $$TablePlaylistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.tablePlaylists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablePlaylistsTableOrderingComposer(
            $db: $db,
            $table: $db.tablePlaylists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TableTracksTableOrderingComposer get trackId {
    final $$TableTracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tableTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableTracksTableOrderingComposer(
            $db: $db,
            $table: $db.tableTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablePlaylistTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablePlaylistTracksTable> {
  $$TablePlaylistTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TablePlaylistsTableAnnotationComposer get playlistId {
    final $$TablePlaylistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.playlistId,
      referencedTable: $db.tablePlaylists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablePlaylistsTableAnnotationComposer(
            $db: $db,
            $table: $db.tablePlaylists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TableTracksTableAnnotationComposer get trackId {
    final $$TableTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.tableTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.tableTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablePlaylistTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablePlaylistTracksTable,
          TablePlaylistTrack,
          $$TablePlaylistTracksTableFilterComposer,
          $$TablePlaylistTracksTableOrderingComposer,
          $$TablePlaylistTracksTableAnnotationComposer,
          $$TablePlaylistTracksTableCreateCompanionBuilder,
          $$TablePlaylistTracksTableUpdateCompanionBuilder,
          (TablePlaylistTrack, $$TablePlaylistTracksTableReferences),
          TablePlaylistTrack,
          PrefetchHooks Function({bool playlistId, bool trackId})
        > {
  $$TablePlaylistTracksTableTableManager(
    _$AppDatabase db,
    $TablePlaylistTracksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TablePlaylistTracksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TablePlaylistTracksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TablePlaylistTracksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> playlistId = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TablePlaylistTracksCompanion(
                playlistId: playlistId,
                trackId: trackId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int playlistId,
                required int trackId,
                Value<int> rowid = const Value.absent(),
              }) => TablePlaylistTracksCompanion.insert(
                playlistId: playlistId,
                trackId: trackId,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$TablePlaylistTracksTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({playlistId = false, trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (playlistId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.playlistId,
                            referencedTable:
                                $$TablePlaylistTracksTableReferences
                                    ._playlistIdTable(db),
                            referencedColumn:
                                $$TablePlaylistTracksTableReferences
                                    ._playlistIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (trackId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.trackId,
                            referencedTable:
                                $$TablePlaylistTracksTableReferences
                                    ._trackIdTable(db),
                            referencedColumn:
                                $$TablePlaylistTracksTableReferences
                                    ._trackIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TablePlaylistTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablePlaylistTracksTable,
      TablePlaylistTrack,
      $$TablePlaylistTracksTableFilterComposer,
      $$TablePlaylistTracksTableOrderingComposer,
      $$TablePlaylistTracksTableAnnotationComposer,
      $$TablePlaylistTracksTableCreateCompanionBuilder,
      $$TablePlaylistTracksTableUpdateCompanionBuilder,
      (TablePlaylistTrack, $$TablePlaylistTracksTableReferences),
      TablePlaylistTrack,
      PrefetchHooks Function({bool playlistId, bool trackId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TableBaseFoldersTableTableManager get tableBaseFolders =>
      $$TableBaseFoldersTableTableManager(_db, _db.tableBaseFolders);
  $$TableTracksTableTableManager get tableTracks =>
      $$TableTracksTableTableManager(_db, _db.tableTracks);
  $$TablePlaylistsTableTableManager get tablePlaylists =>
      $$TablePlaylistsTableTableManager(_db, _db.tablePlaylists);
  $$TablePlaylistTracksTableTableManager get tablePlaylistTracks =>
      $$TablePlaylistTracksTableTableManager(_db, _db.tablePlaylistTracks);
}

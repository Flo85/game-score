// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, Game> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberOfRowsMeta = const VerificationMeta(
    'numberOfRows',
  );
  @override
  late final GeneratedColumn<int> numberOfRows = GeneratedColumn<int>(
    'number_of_rows',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(9),
  );
  static const VerificationMeta _writableMeta = const VerificationMeta(
    'writable',
  );
  @override
  late final GeneratedColumn<bool> writable = GeneratedColumn<bool>(
    'writable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("writable" IN (0, 1))',
    ),
  );
  static const VerificationMeta _playersJsonMeta = const VerificationMeta(
    'playersJson',
  );
  @override
  late final GeneratedColumn<String> playersJson = GeneratedColumn<String>(
    'players_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoresJsonMeta = const VerificationMeta(
    'scoresJson',
  );
  @override
  late final GeneratedColumn<String> scoresJson = GeneratedColumn<String>(
    'scores_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    numberOfRows,
    writable,
    playersJson,
    scoresJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<Game> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('number_of_rows')) {
      context.handle(
        _numberOfRowsMeta,
        numberOfRows.isAcceptableOrUnknown(
          data['number_of_rows']!,
          _numberOfRowsMeta,
        ),
      );
    }
    if (data.containsKey('writable')) {
      context.handle(
        _writableMeta,
        writable.isAcceptableOrUnknown(data['writable']!, _writableMeta),
      );
    } else if (isInserting) {
      context.missing(_writableMeta);
    }
    if (data.containsKey('players_json')) {
      context.handle(
        _playersJsonMeta,
        playersJson.isAcceptableOrUnknown(
          data['players_json']!,
          _playersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_playersJsonMeta);
    }
    if (data.containsKey('scores_json')) {
      context.handle(
        _scoresJsonMeta,
        scoresJson.isAcceptableOrUnknown(data['scores_json']!, _scoresJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_scoresJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Game map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Game(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      numberOfRows: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}number_of_rows'],
      )!,
      writable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}writable'],
      )!,
      playersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}players_json'],
      )!,
      scoresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scores_json'],
      )!,
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class Game extends DataClass implements Insertable<Game> {
  final String id;
  final DateTime createdAt;
  final int numberOfRows;
  final bool writable;
  final String playersJson;
  final String scoresJson;
  const Game({
    required this.id,
    required this.createdAt,
    required this.numberOfRows,
    required this.writable,
    required this.playersJson,
    required this.scoresJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['number_of_rows'] = Variable<int>(numberOfRows);
    map['writable'] = Variable<bool>(writable);
    map['players_json'] = Variable<String>(playersJson);
    map['scores_json'] = Variable<String>(scoresJson);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      numberOfRows: Value(numberOfRows),
      writable: Value(writable),
      playersJson: Value(playersJson),
      scoresJson: Value(scoresJson),
    );
  }

  factory Game.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Game(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      numberOfRows: serializer.fromJson<int>(json['numberOfRows']),
      writable: serializer.fromJson<bool>(json['writable']),
      playersJson: serializer.fromJson<String>(json['playersJson']),
      scoresJson: serializer.fromJson<String>(json['scoresJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'numberOfRows': serializer.toJson<int>(numberOfRows),
      'writable': serializer.toJson<bool>(writable),
      'playersJson': serializer.toJson<String>(playersJson),
      'scoresJson': serializer.toJson<String>(scoresJson),
    };
  }

  Game copyWith({
    String? id,
    DateTime? createdAt,
    int? numberOfRows,
    bool? writable,
    String? playersJson,
    String? scoresJson,
  }) => Game(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    numberOfRows: numberOfRows ?? this.numberOfRows,
    writable: writable ?? this.writable,
    playersJson: playersJson ?? this.playersJson,
    scoresJson: scoresJson ?? this.scoresJson,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      numberOfRows: data.numberOfRows.present
          ? data.numberOfRows.value
          : this.numberOfRows,
      writable: data.writable.present ? data.writable.value : this.writable,
      playersJson: data.playersJson.present
          ? data.playersJson.value
          : this.playersJson,
      scoresJson: data.scoresJson.present
          ? data.scoresJson.value
          : this.scoresJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('numberOfRows: $numberOfRows, ')
          ..write('writable: $writable, ')
          ..write('playersJson: $playersJson, ')
          ..write('scoresJson: $scoresJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    numberOfRows,
    writable,
    playersJson,
    scoresJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.numberOfRows == this.numberOfRows &&
          other.writable == this.writable &&
          other.playersJson == this.playersJson &&
          other.scoresJson == this.scoresJson);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<int> numberOfRows;
  final Value<bool> writable;
  final Value<String> playersJson;
  final Value<String> scoresJson;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.numberOfRows = const Value.absent(),
    this.writable = const Value.absent(),
    this.playersJson = const Value.absent(),
    this.scoresJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required DateTime createdAt,
    this.numberOfRows = const Value.absent(),
    required bool writable,
    required String playersJson,
    required String scoresJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       writable = Value(writable),
       playersJson = Value(playersJson),
       scoresJson = Value(scoresJson);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<int>? numberOfRows,
    Expression<bool>? writable,
    Expression<String>? playersJson,
    Expression<String>? scoresJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (numberOfRows != null) 'number_of_rows': numberOfRows,
      if (writable != null) 'writable': writable,
      if (playersJson != null) 'players_json': playersJson,
      if (scoresJson != null) 'scores_json': scoresJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<int>? numberOfRows,
    Value<bool>? writable,
    Value<String>? playersJson,
    Value<String>? scoresJson,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      numberOfRows: numberOfRows ?? this.numberOfRows,
      writable: writable ?? this.writable,
      playersJson: playersJson ?? this.playersJson,
      scoresJson: scoresJson ?? this.scoresJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (numberOfRows.present) {
      map['number_of_rows'] = Variable<int>(numberOfRows.value);
    }
    if (writable.present) {
      map['writable'] = Variable<bool>(writable.value);
    }
    if (playersJson.present) {
      map['players_json'] = Variable<String>(playersJson.value);
    }
    if (scoresJson.present) {
      map['scores_json'] = Variable<String>(scoresJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('numberOfRows: $numberOfRows, ')
          ..write('writable: $writable, ')
          ..write('playersJson: $playersJson, ')
          ..write('scoresJson: $scoresJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedPlayersTable extends SavedPlayers
    with TableInfo<$SavedPlayersTable, SavedPlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedPlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedPlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedPlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedPlayer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $SavedPlayersTable createAlias(String alias) {
    return $SavedPlayersTable(attachedDatabase, alias);
  }
}

class SavedPlayer extends DataClass implements Insertable<SavedPlayer> {
  final String id;
  final String name;
  const SavedPlayer({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  SavedPlayersCompanion toCompanion(bool nullToAbsent) {
    return SavedPlayersCompanion(id: Value(id), name: Value(name));
  }

  factory SavedPlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedPlayer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  SavedPlayer copyWith({String? id, String? name}) =>
      SavedPlayer(id: id ?? this.id, name: name ?? this.name);
  SavedPlayer copyWithCompanion(SavedPlayersCompanion data) {
    return SavedPlayer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedPlayer(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedPlayer && other.id == this.id && other.name == this.name);
}

class SavedPlayersCompanion extends UpdateCompanion<SavedPlayer> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const SavedPlayersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedPlayersCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<SavedPlayer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedPlayersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return SavedPlayersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedPlayersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $SavedPlayersTable savedPlayers = $SavedPlayersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, savedPlayers];
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String id,
      required DateTime createdAt,
      Value<int> numberOfRows,
      required bool writable,
      required String playersJson,
      required String scoresJson,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<int> numberOfRows,
      Value<bool> writable,
      Value<String> playersJson,
      Value<String> scoresJson,
      Value<int> rowid,
    });

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numberOfRows => $composableBuilder(
    column: $table.numberOfRows,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get writable => $composableBuilder(
    column: $table.writable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playersJson => $composableBuilder(
    column: $table.playersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numberOfRows => $composableBuilder(
    column: $table.numberOfRows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get writable => $composableBuilder(
    column: $table.writable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playersJson => $composableBuilder(
    column: $table.playersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get numberOfRows => $composableBuilder(
    column: $table.numberOfRows,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get writable =>
      $composableBuilder(column: $table.writable, builder: (column) => column);

  GeneratedColumn<String> get playersJson => $composableBuilder(
    column: $table.playersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => column,
  );
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          Game,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
          Game,
          PrefetchHooks Function()
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> numberOfRows = const Value.absent(),
                Value<bool> writable = const Value.absent(),
                Value<String> playersJson = const Value.absent(),
                Value<String> scoresJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                createdAt: createdAt,
                numberOfRows: numberOfRows,
                writable: writable,
                playersJson: playersJson,
                scoresJson: scoresJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                Value<int> numberOfRows = const Value.absent(),
                required bool writable,
                required String playersJson,
                required String scoresJson,
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                createdAt: createdAt,
                numberOfRows: numberOfRows,
                writable: writable,
                playersJson: playersJson,
                scoresJson: scoresJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      Game,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (Game, BaseReferences<_$AppDatabase, $GamesTable, Game>),
      Game,
      PrefetchHooks Function()
    >;
typedef $$SavedPlayersTableCreateCompanionBuilder =
    SavedPlayersCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$SavedPlayersTableUpdateCompanionBuilder =
    SavedPlayersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$SavedPlayersTableFilterComposer
    extends Composer<_$AppDatabase, $SavedPlayersTable> {
  $$SavedPlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedPlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedPlayersTable> {
  $$SavedPlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedPlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedPlayersTable> {
  $$SavedPlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$SavedPlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedPlayersTable,
          SavedPlayer,
          $$SavedPlayersTableFilterComposer,
          $$SavedPlayersTableOrderingComposer,
          $$SavedPlayersTableAnnotationComposer,
          $$SavedPlayersTableCreateCompanionBuilder,
          $$SavedPlayersTableUpdateCompanionBuilder,
          (
            SavedPlayer,
            BaseReferences<_$AppDatabase, $SavedPlayersTable, SavedPlayer>,
          ),
          SavedPlayer,
          PrefetchHooks Function()
        > {
  $$SavedPlayersTableTableManager(_$AppDatabase db, $SavedPlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedPlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedPlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedPlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedPlayersCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => SavedPlayersCompanion.insert(
                id: id,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedPlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedPlayersTable,
      SavedPlayer,
      $$SavedPlayersTableFilterComposer,
      $$SavedPlayersTableOrderingComposer,
      $$SavedPlayersTableAnnotationComposer,
      $$SavedPlayersTableCreateCompanionBuilder,
      $$SavedPlayersTableUpdateCompanionBuilder,
      (
        SavedPlayer,
        BaseReferences<_$AppDatabase, $SavedPlayersTable, SavedPlayer>,
      ),
      SavedPlayer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$SavedPlayersTableTableManager get savedPlayers =>
      $$SavedPlayersTableTableManager(_db, _db.savedPlayers);
}

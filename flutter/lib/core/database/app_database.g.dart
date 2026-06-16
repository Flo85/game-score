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
  static const VerificationMeta _gameTypeMeta = const VerificationMeta(
    'gameType',
  );
  @override
  late final GeneratedColumn<String> gameType = GeneratedColumn<String>(
    'game_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('faraway'),
  );
  static const VerificationMeta _finishedMeta = const VerificationMeta(
    'finished',
  );
  @override
  late final GeneratedColumn<bool> finished = GeneratedColumn<bool>(
    'finished',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("finished" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, gameType, finished];
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
    if (data.containsKey('game_type')) {
      context.handle(
        _gameTypeMeta,
        gameType.isAcceptableOrUnknown(data['game_type']!, _gameTypeMeta),
      );
    }
    if (data.containsKey('finished')) {
      context.handle(
        _finishedMeta,
        finished.isAcceptableOrUnknown(data['finished']!, _finishedMeta),
      );
    } else if (isInserting) {
      context.missing(_finishedMeta);
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
      gameType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_type'],
      )!,
      finished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}finished'],
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
  final String gameType;
  final bool finished;
  const Game({
    required this.id,
    required this.createdAt,
    required this.gameType,
    required this.finished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['game_type'] = Variable<String>(gameType);
    map['finished'] = Variable<bool>(finished);
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      gameType: Value(gameType),
      finished: Value(finished),
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
      gameType: serializer.fromJson<String>(json['gameType']),
      finished: serializer.fromJson<bool>(json['finished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'gameType': serializer.toJson<String>(gameType),
      'finished': serializer.toJson<bool>(finished),
    };
  }

  Game copyWith({
    String? id,
    DateTime? createdAt,
    String? gameType,
    bool? finished,
  }) => Game(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    gameType: gameType ?? this.gameType,
    finished: finished ?? this.finished,
  );
  Game copyWithCompanion(GamesCompanion data) {
    return Game(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      gameType: data.gameType.present ? data.gameType.value : this.gameType,
      finished: data.finished.present ? data.finished.value : this.finished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Game(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('gameType: $gameType, ')
          ..write('finished: $finished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, gameType, finished);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Game &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.gameType == this.gameType &&
          other.finished == this.finished);
}

class GamesCompanion extends UpdateCompanion<Game> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<String> gameType;
  final Value<bool> finished;
  final Value<int> rowid;
  const GamesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.gameType = const Value.absent(),
    this.finished = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String id,
    required DateTime createdAt,
    this.gameType = const Value.absent(),
    required bool finished,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       createdAt = Value(createdAt),
       finished = Value(finished);
  static Insertable<Game> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? gameType,
    Expression<bool>? finished,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (gameType != null) 'game_type': gameType,
      if (finished != null) 'finished': finished,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<String>? gameType,
    Value<bool>? finished,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      gameType: gameType ?? this.gameType,
      finished: finished ?? this.finished,
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
    if (gameType.present) {
      map['game_type'] = Variable<String>(gameType.value);
    }
    if (finished.present) {
      map['finished'] = Variable<bool>(finished.value);
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
          ..write('gameType: $gameType, ')
          ..write('finished: $finished, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GamePlayersTable extends GamePlayers
    with TableInfo<$GamePlayersTable, GamePlayer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamePlayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES games (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _playerIdMeta = const VerificationMeta(
    'playerId',
  );
  @override
  late final GeneratedColumn<String> playerId = GeneratedColumn<String>(
    'player_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _playerNameMeta = const VerificationMeta(
    'playerName',
  );
  @override
  late final GeneratedColumn<String> playerName = GeneratedColumn<String>(
    'player_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    gameId,
    playerId,
    playerName,
    position,
    scoresJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_players';
  @override
  VerificationContext validateIntegrity(
    Insertable<GamePlayer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('player_id')) {
      context.handle(
        _playerIdMeta,
        playerId.isAcceptableOrUnknown(data['player_id']!, _playerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playerIdMeta);
    }
    if (data.containsKey('player_name')) {
      context.handle(
        _playerNameMeta,
        playerName.isAcceptableOrUnknown(data['player_name']!, _playerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_playerNameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('scores_json')) {
      context.handle(
        _scoresJsonMeta,
        scoresJson.isAcceptableOrUnknown(data['scores_json']!, _scoresJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId, position};
  @override
  GamePlayer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GamePlayer(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      playerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_id'],
      )!,
      playerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}player_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      scoresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scores_json'],
      )!,
    );
  }

  @override
  $GamePlayersTable createAlias(String alias) {
    return $GamePlayersTable(attachedDatabase, alias);
  }
}

class GamePlayer extends DataClass implements Insertable<GamePlayer> {
  final String gameId;
  final String playerId;
  final String playerName;
  final int position;
  final String scoresJson;
  const GamePlayer({
    required this.gameId,
    required this.playerId,
    required this.playerName,
    required this.position,
    required this.scoresJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    map['player_id'] = Variable<String>(playerId);
    map['player_name'] = Variable<String>(playerName);
    map['position'] = Variable<int>(position);
    map['scores_json'] = Variable<String>(scoresJson);
    return map;
  }

  GamePlayersCompanion toCompanion(bool nullToAbsent) {
    return GamePlayersCompanion(
      gameId: Value(gameId),
      playerId: Value(playerId),
      playerName: Value(playerName),
      position: Value(position),
      scoresJson: Value(scoresJson),
    );
  }

  factory GamePlayer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GamePlayer(
      gameId: serializer.fromJson<String>(json['gameId']),
      playerId: serializer.fromJson<String>(json['playerId']),
      playerName: serializer.fromJson<String>(json['playerName']),
      position: serializer.fromJson<int>(json['position']),
      scoresJson: serializer.fromJson<String>(json['scoresJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'playerId': serializer.toJson<String>(playerId),
      'playerName': serializer.toJson<String>(playerName),
      'position': serializer.toJson<int>(position),
      'scoresJson': serializer.toJson<String>(scoresJson),
    };
  }

  GamePlayer copyWith({
    String? gameId,
    String? playerId,
    String? playerName,
    int? position,
    String? scoresJson,
  }) => GamePlayer(
    gameId: gameId ?? this.gameId,
    playerId: playerId ?? this.playerId,
    playerName: playerName ?? this.playerName,
    position: position ?? this.position,
    scoresJson: scoresJson ?? this.scoresJson,
  );
  GamePlayer copyWithCompanion(GamePlayersCompanion data) {
    return GamePlayer(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      playerId: data.playerId.present ? data.playerId.value : this.playerId,
      playerName: data.playerName.present
          ? data.playerName.value
          : this.playerName,
      position: data.position.present ? data.position.value : this.position,
      scoresJson: data.scoresJson.present
          ? data.scoresJson.value
          : this.scoresJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GamePlayer(')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('playerName: $playerName, ')
          ..write('position: $position, ')
          ..write('scoresJson: $scoresJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(gameId, playerId, playerName, position, scoresJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GamePlayer &&
          other.gameId == this.gameId &&
          other.playerId == this.playerId &&
          other.playerName == this.playerName &&
          other.position == this.position &&
          other.scoresJson == this.scoresJson);
}

class GamePlayersCompanion extends UpdateCompanion<GamePlayer> {
  final Value<String> gameId;
  final Value<String> playerId;
  final Value<String> playerName;
  final Value<int> position;
  final Value<String> scoresJson;
  final Value<int> rowid;
  const GamePlayersCompanion({
    this.gameId = const Value.absent(),
    this.playerId = const Value.absent(),
    this.playerName = const Value.absent(),
    this.position = const Value.absent(),
    this.scoresJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamePlayersCompanion.insert({
    required String gameId,
    required String playerId,
    required String playerName,
    required int position,
    this.scoresJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId),
       playerId = Value(playerId),
       playerName = Value(playerName),
       position = Value(position);
  static Insertable<GamePlayer> custom({
    Expression<String>? gameId,
    Expression<String>? playerId,
    Expression<String>? playerName,
    Expression<int>? position,
    Expression<String>? scoresJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (playerId != null) 'player_id': playerId,
      if (playerName != null) 'player_name': playerName,
      if (position != null) 'position': position,
      if (scoresJson != null) 'scores_json': scoresJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamePlayersCompanion copyWith({
    Value<String>? gameId,
    Value<String>? playerId,
    Value<String>? playerName,
    Value<int>? position,
    Value<String>? scoresJson,
    Value<int>? rowid,
  }) {
    return GamePlayersCompanion(
      gameId: gameId ?? this.gameId,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      position: position ?? this.position,
      scoresJson: scoresJson ?? this.scoresJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (playerId.present) {
      map['player_id'] = Variable<String>(playerId.value);
    }
    if (playerName.present) {
      map['player_name'] = Variable<String>(playerName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
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
    return (StringBuffer('GamePlayersCompanion(')
          ..write('gameId: $gameId, ')
          ..write('playerId: $playerId, ')
          ..write('playerName: $playerName, ')
          ..write('position: $position, ')
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
  late final $GamePlayersTable gamePlayers = $GamePlayersTable(this);
  late final $SavedPlayersTable savedPlayers = $SavedPlayersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    games,
    gamePlayers,
    savedPlayers,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'games',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_players', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String id,
      required DateTime createdAt,
      Value<String> gameType,
      required bool finished,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<String> gameType,
      Value<bool> finished,
      Value<int> rowid,
    });

final class $$GamesTableReferences
    extends BaseReferences<_$AppDatabase, $GamesTable, Game> {
  $$GamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GamePlayersTable, List<GamePlayer>>
  _gamePlayersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gamePlayers,
    aliasName: 'games__id__game_players__game_id',
  );

  $$GamePlayersTableProcessedTableManager get gamePlayersRefs {
    final manager = $$GamePlayersTableTableManager(
      $_db,
      $_db.gamePlayers,
    ).filter((f) => f.gameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gamePlayersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get finished => $composableBuilder(
    column: $table.finished,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gamePlayersRefs(
    Expression<bool> Function($$GamePlayersTableFilterComposer f) f,
  ) {
    final $$GamePlayersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableFilterComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get gameType => $composableBuilder(
    column: $table.gameType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get finished => $composableBuilder(
    column: $table.finished,
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

  GeneratedColumn<String> get gameType =>
      $composableBuilder(column: $table.gameType, builder: (column) => column);

  GeneratedColumn<bool> get finished =>
      $composableBuilder(column: $table.finished, builder: (column) => column);

  Expression<T> gamePlayersRefs<T extends Object>(
    Expression<T> Function($$GamePlayersTableAnnotationComposer a) f,
  ) {
    final $$GamePlayersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gamePlayers,
      getReferencedColumn: (t) => t.gameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamePlayersTableAnnotationComposer(
            $db: $db,
            $table: $db.gamePlayers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Game, $$GamesTableReferences),
          Game,
          PrefetchHooks Function({bool gamePlayersRefs})
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
                Value<String> gameType = const Value.absent(),
                Value<bool> finished = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                id: id,
                createdAt: createdAt,
                gameType: gameType,
                finished: finished,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime createdAt,
                Value<String> gameType = const Value.absent(),
                required bool finished,
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                id: id,
                createdAt: createdAt,
                gameType: gameType,
                finished: finished,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GamesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({gamePlayersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gamePlayersRefs) db.gamePlayers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gamePlayersRefs)
                    await $_getPrefetchedData<Game, $GamesTable, GamePlayer>(
                      currentTable: table,
                      referencedTable: $$GamesTableReferences
                          ._gamePlayersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$GamesTableReferences(db, table, p0).gamePlayersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.gameId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (Game, $$GamesTableReferences),
      Game,
      PrefetchHooks Function({bool gamePlayersRefs})
    >;
typedef $$GamePlayersTableCreateCompanionBuilder =
    GamePlayersCompanion Function({
      required String gameId,
      required String playerId,
      required String playerName,
      required int position,
      Value<String> scoresJson,
      Value<int> rowid,
    });
typedef $$GamePlayersTableUpdateCompanionBuilder =
    GamePlayersCompanion Function({
      Value<String> gameId,
      Value<String> playerId,
      Value<String> playerName,
      Value<int> position,
      Value<String> scoresJson,
      Value<int> rowid,
    });

final class $$GamePlayersTableReferences
    extends BaseReferences<_$AppDatabase, $GamePlayersTable, GamePlayer> {
  $$GamePlayersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GamesTable _gameIdTable(_$AppDatabase db) =>
      db.games.createAlias('game_players__game_id__games__id');

  $$GamesTableProcessedTableManager get gameId {
    final $_column = $_itemColumn<String>('game_id')!;

    final manager = $$GamesTableTableManager(
      $_db,
      $_db.games,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GamePlayersTableFilterComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnFilters(column),
  );

  $$GamesTableFilterComposer get gameId {
    final $$GamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableFilterComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableOrderingComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get playerId => $composableBuilder(
    column: $table.playerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$GamesTableOrderingComposer get gameId {
    final $$GamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableOrderingComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamePlayersTable> {
  $$GamePlayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get playerId =>
      $composableBuilder(column: $table.playerId, builder: (column) => column);

  GeneratedColumn<String> get playerName => $composableBuilder(
    column: $table.playerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get scoresJson => $composableBuilder(
    column: $table.scoresJson,
    builder: (column) => column,
  );

  $$GamesTableAnnotationComposer get gameId {
    final $$GamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.gameId,
      referencedTable: $db.games,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GamesTableAnnotationComposer(
            $db: $db,
            $table: $db.games,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GamePlayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamePlayersTable,
          GamePlayer,
          $$GamePlayersTableFilterComposer,
          $$GamePlayersTableOrderingComposer,
          $$GamePlayersTableAnnotationComposer,
          $$GamePlayersTableCreateCompanionBuilder,
          $$GamePlayersTableUpdateCompanionBuilder,
          (GamePlayer, $$GamePlayersTableReferences),
          GamePlayer,
          PrefetchHooks Function({bool gameId})
        > {
  $$GamePlayersTableTableManager(_$AppDatabase db, $GamePlayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamePlayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamePlayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamePlayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameId = const Value.absent(),
                Value<String> playerId = const Value.absent(),
                Value<String> playerName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> scoresJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePlayersCompanion(
                gameId: gameId,
                playerId: playerId,
                playerName: playerName,
                position: position,
                scoresJson: scoresJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameId,
                required String playerId,
                required String playerName,
                required int position,
                Value<String> scoresJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamePlayersCompanion.insert(
                gameId: gameId,
                playerId: playerId,
                playerName: playerName,
                position: position,
                scoresJson: scoresJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GamePlayersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                    if (gameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.gameId,
                                referencedTable: $$GamePlayersTableReferences
                                    ._gameIdTable(db),
                                referencedColumn: $$GamePlayersTableReferences
                                    ._gameIdTable(db)
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

typedef $$GamePlayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamePlayersTable,
      GamePlayer,
      $$GamePlayersTableFilterComposer,
      $$GamePlayersTableOrderingComposer,
      $$GamePlayersTableAnnotationComposer,
      $$GamePlayersTableCreateCompanionBuilder,
      $$GamePlayersTableUpdateCompanionBuilder,
      (GamePlayer, $$GamePlayersTableReferences),
      GamePlayer,
      PrefetchHooks Function({bool gameId})
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
  $$GamePlayersTableTableManager get gamePlayers =>
      $$GamePlayersTableTableManager(_db, _db.gamePlayers);
  $$SavedPlayersTableTableManager get savedPlayers =>
      $$SavedPlayersTableTableManager(_db, _db.savedPlayers);
}

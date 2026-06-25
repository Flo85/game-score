// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

@ProviderFor(farawayRepository)
final farawayRepositoryProvider = FarawayRepositoryProvider._();

final class FarawayRepositoryProvider
    extends
        $FunctionalProvider<
          FarawayRepository,
          FarawayRepository,
          FarawayRepository
        >
    with $Provider<FarawayRepository> {
  FarawayRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'farawayRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$farawayRepositoryHash();

  @$internal
  @override
  $ProviderElement<FarawayRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FarawayRepository create(Ref ref) {
    return farawayRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FarawayRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FarawayRepository>(value),
    );
  }
}

String _$farawayRepositoryHash() => r'61f061bf9856cb0424bd355a8a8b65c1c80beef3';

@ProviderFor(savedPlayersRepository)
final savedPlayersRepositoryProvider = SavedPlayersRepositoryProvider._();

final class SavedPlayersRepositoryProvider
    extends
        $FunctionalProvider<
          SavedPlayersRepository,
          SavedPlayersRepository,
          SavedPlayersRepository
        >
    with $Provider<SavedPlayersRepository> {
  SavedPlayersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedPlayersRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedPlayersRepositoryHash();

  @$internal
  @override
  $ProviderElement<SavedPlayersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavedPlayersRepository create(Ref ref) {
    return savedPlayersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavedPlayersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavedPlayersRepository>(value),
    );
  }
}

String _$savedPlayersRepositoryHash() =>
    r'6e02d9b106dad5e20f8c8f501edd8c8b514c8133';

@ProviderFor(savedPlayersList)
final savedPlayersListProvider = SavedPlayersListProvider._();

final class SavedPlayersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Player>>,
          List<Player>,
          Stream<List<Player>>
        >
    with $FutureModifier<List<Player>>, $StreamProvider<List<Player>> {
  SavedPlayersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savedPlayersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savedPlayersListHash();

  @$internal
  @override
  $StreamProviderElement<List<Player>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Player>> create(Ref ref) {
    return savedPlayersList(ref);
  }
}

String _$savedPlayersListHash() => r'bd7247c3f228a0037881e3028da073697f85ed27';

@ProviderFor(gameHistory)
final gameHistoryProvider = GameHistoryProvider._();

final class GameHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FarawayGame>>,
          List<FarawayGame>,
          Stream<List<FarawayGame>>
        >
    with
        $FutureModifier<List<FarawayGame>>,
        $StreamProvider<List<FarawayGame>> {
  GameHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<FarawayGame>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FarawayGame>> create(Ref ref) {
    return gameHistory(ref);
  }
}

String _$gameHistoryHash() => r'c6ac9f8cedddac5761f6079017eb50de7935b8ce';

@ProviderFor(farawayPlayerStats)
final farawayPlayerStatsProvider = FarawayPlayerStatsFamily._();

final class FarawayPlayerStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<FarawayPlayerStats>,
          FarawayPlayerStats,
          FutureOr<FarawayPlayerStats>
        >
    with
        $FutureModifier<FarawayPlayerStats>,
        $FutureProvider<FarawayPlayerStats> {
  FarawayPlayerStatsProvider._({
    required FarawayPlayerStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'farawayPlayerStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$farawayPlayerStatsHash();

  @override
  String toString() {
    return r'farawayPlayerStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FarawayPlayerStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FarawayPlayerStats> create(Ref ref) {
    final argument = this.argument as String;
    return farawayPlayerStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FarawayPlayerStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$farawayPlayerStatsHash() =>
    r'2c7f5885c9c81d6d0e3584349e89b737c947780b';

final class FarawayPlayerStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FarawayPlayerStats>, String> {
  FarawayPlayerStatsFamily._()
    : super(
        retry: null,
        name: r'farawayPlayerStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FarawayPlayerStatsProvider call(String playerId) =>
      FarawayPlayerStatsProvider._(argument: playerId, from: this);

  @override
  String toString() => r'farawayPlayerStatsProvider';
}

@ProviderFor(playerCarnetSummary)
final playerCarnetSummaryProvider = PlayerCarnetSummaryFamily._();

final class PlayerCarnetSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<({int games, int wins})>,
          ({int games, int wins}),
          FutureOr<({int games, int wins})>
        >
    with
        $FutureModifier<({int games, int wins})>,
        $FutureProvider<({int games, int wins})> {
  PlayerCarnetSummaryProvider._({
    required PlayerCarnetSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'playerCarnetSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerCarnetSummaryHash();

  @override
  String toString() {
    return r'playerCarnetSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<({int games, int wins})> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({int games, int wins})> create(Ref ref) {
    final argument = this.argument as String;
    return playerCarnetSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerCarnetSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerCarnetSummaryHash() =>
    r'07c598dee10cd08e01c676b4078d16ce5596d8ce';

final class PlayerCarnetSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<({int games, int wins})>, String> {
  PlayerCarnetSummaryFamily._()
    : super(
        retry: null,
        name: r'playerCarnetSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerCarnetSummaryProvider call(String playerId) =>
      PlayerCarnetSummaryProvider._(argument: playerId, from: this);

  @override
  String toString() => r'playerCarnetSummaryProvider';
}

@ProviderFor(playerStatsByGame)
final playerStatsByGameProvider = PlayerStatsByGameFamily._();

final class PlayerStatsByGameProvider
    extends
        $FunctionalProvider<
          AsyncValue<({int games, int wins})>,
          ({int games, int wins}),
          FutureOr<({int games, int wins})>
        >
    with
        $FutureModifier<({int games, int wins})>,
        $FutureProvider<({int games, int wins})> {
  PlayerStatsByGameProvider._({
    required PlayerStatsByGameFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'playerStatsByGameProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$playerStatsByGameHash();

  @override
  String toString() {
    return r'playerStatsByGameProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<({int games, int wins})> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<({int games, int wins})> create(Ref ref) {
    final argument = this.argument as (String, String);
    return playerStatsByGame(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerStatsByGameProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playerStatsByGameHash() => r'ec6f24d01a46d2a31ff308128a53acce600aa591';

final class PlayerStatsByGameFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<({int games, int wins})>,
          (String, String)
        > {
  PlayerStatsByGameFamily._()
    : super(
        retry: null,
        name: r'playerStatsByGameProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlayerStatsByGameProvider call(String playerId, String gameType) =>
      PlayerStatsByGameProvider._(argument: (playerId, gameType), from: this);

  @override
  String toString() => r'playerStatsByGameProvider';
}

@ProviderFor(CurrentGame)
final currentGameProvider = CurrentGameProvider._();

final class CurrentGameProvider
    extends $NotifierProvider<CurrentGame, FarawayGame?> {
  CurrentGameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGameHash();

  @$internal
  @override
  CurrentGame create() => CurrentGame();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FarawayGame? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FarawayGame?>(value),
    );
  }
}

String _$currentGameHash() => r'7ba1453cdd3a2ab0facb87395e7e307489e9d386';

abstract class _$CurrentGame extends $Notifier<FarawayGame?> {
  FarawayGame? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FarawayGame?, FarawayGame?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FarawayGame?, FarawayGame?>,
              FarawayGame?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SetupPlayers)
final setupPlayersProvider = SetupPlayersProvider._();

final class SetupPlayersProvider
    extends $NotifierProvider<SetupPlayers, List<Player>> {
  SetupPlayersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setupPlayersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setupPlayersHash();

  @$internal
  @override
  SetupPlayers create() => SetupPlayers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Player> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Player>>(value),
    );
  }
}

String _$setupPlayersHash() => r'0625570ca91ae07e6ed0ba4af36443bf48b379ce';

abstract class _$SetupPlayers extends $Notifier<List<Player>> {
  List<Player> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Player>, List<Player>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Player>, List<Player>>,
              List<Player>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

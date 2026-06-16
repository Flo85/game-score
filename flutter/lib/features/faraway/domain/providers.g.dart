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

String _$currentGameHash() => r'5855a62d2f53525ccb6468b79cb08e47b370dcaa';

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

String _$setupPlayersHash() => r'befb8e8654b7a8282681f7faf68e38bbd6ffb857';

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

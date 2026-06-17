// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(genericRepository)
final genericRepositoryProvider = GenericRepositoryProvider._();

final class GenericRepositoryProvider
    extends
        $FunctionalProvider<
          GenericRepository,
          GenericRepository,
          GenericRepository
        >
    with $Provider<GenericRepository> {
  GenericRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genericRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericRepositoryHash();

  @$internal
  @override
  $ProviderElement<GenericRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GenericRepository create(Ref ref) {
    return genericRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenericRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenericRepository>(value),
    );
  }
}

String _$genericRepositoryHash() => r'3406fe67a0e4d6f61b4488a3b32652e18d455763';

@ProviderFor(CurrentGenericGame)
final currentGenericGameProvider = CurrentGenericGameProvider._();

final class CurrentGenericGameProvider
    extends $NotifierProvider<CurrentGenericGame, GenericGame?> {
  CurrentGenericGameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGenericGameProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGenericGameHash();

  @$internal
  @override
  CurrentGenericGame create() => CurrentGenericGame();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GenericGame? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GenericGame?>(value),
    );
  }
}

String _$currentGenericGameHash() =>
    r'1162196054795ed26666eb2b935f22f9586bb779';

abstract class _$CurrentGenericGame extends $Notifier<GenericGame?> {
  GenericGame? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<GenericGame?, GenericGame?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GenericGame?, GenericGame?>,
              GenericGame?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(genericGameHistory)
final genericGameHistoryProvider = GenericGameHistoryProvider._();

final class GenericGameHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GenericGame>>,
          List<GenericGame>,
          Stream<List<GenericGame>>
        >
    with
        $FutureModifier<List<GenericGame>>,
        $StreamProvider<List<GenericGame>> {
  GenericGameHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genericGameHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericGameHistoryHash();

  @$internal
  @override
  $StreamProviderElement<List<GenericGame>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GenericGame>> create(Ref ref) {
    return genericGameHistory(ref);
  }
}

String _$genericGameHistoryHash() =>
    r'0b8a367cb37503e779afb005f08c7425d6992089';

@ProviderFor(GenericSetupName)
final genericSetupNameProvider = GenericSetupNameProvider._();

final class GenericSetupNameProvider
    extends $NotifierProvider<GenericSetupName, String> {
  GenericSetupNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genericSetupNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericSetupNameHash();

  @$internal
  @override
  GenericSetupName create() => GenericSetupName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$genericSetupNameHash() => r'd793ab9aa738bde1a73cd9b88e24629e904dabd7';

abstract class _$GenericSetupName extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(GenericSetupPlayers)
final genericSetupPlayersProvider = GenericSetupPlayersProvider._();

final class GenericSetupPlayersProvider
    extends $NotifierProvider<GenericSetupPlayers, List<Player>> {
  GenericSetupPlayersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'genericSetupPlayersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$genericSetupPlayersHash();

  @$internal
  @override
  GenericSetupPlayers create() => GenericSetupPlayers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Player> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Player>>(value),
    );
  }
}

String _$genericSetupPlayersHash() =>
    r'8fa174e76244f0485eca2178084621aed69b12c5';

abstract class _$GenericSetupPlayers extends $Notifier<List<Player>> {
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

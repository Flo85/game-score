// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Game Score';

  @override
  String get chooseGame => 'Choose a game';

  @override
  String get freeGame => 'Free game';

  @override
  String get freeGameSubtitle => 'Round scores, any game';

  @override
  String get history => 'History';

  @override
  String get playerBook => 'Players';

  @override
  String get newGame => 'New game';

  @override
  String get start => 'Start';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get rename => 'Rename';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get irreversible => 'This action is irreversible.';

  @override
  String get noGamesRecorded => 'No games recorded';

  @override
  String get deleteGameQuestion => 'Delete game?';

  @override
  String get inProgress => ' — in progress';

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count players',
      one: '1 player',
    );
    return '$_temp0';
  }

  @override
  String get importJson => 'Import JSON';

  @override
  String get exportJson => 'Export JSON';

  @override
  String importedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games imported',
      one: '1 game imported',
    );
    return '$_temp0';
  }

  @override
  String get noNewGame => 'No new game to import';

  @override
  String importError(String error) {
    return 'Import error: $error';
  }

  @override
  String get fileSaved => 'File saved to Downloads';

  @override
  String get noGameToExport => 'No game to export';

  @override
  String get scoreSheet => 'Score sheet';

  @override
  String get gameEnded => 'Game ended';

  @override
  String get totalAbbrev => 'T';

  @override
  String get roundAbbrev => 'Rnd';

  @override
  String get totalLabel => 'Total';

  @override
  String get roundLabel => 'Round';

  @override
  String get endGameQuestion => 'End game?';

  @override
  String get scoresLocked => 'Scores can no longer be modified.';

  @override
  String get endGame => 'End game';

  @override
  String get endGameAction => 'End';

  @override
  String get maxPlayers => 'Maximum 7 players';

  @override
  String playerIndex(int index) {
    return 'Player $index';
  }

  @override
  String get gameName => 'Game name';

  @override
  String get gameNameHint => 'e.g. Uno, Catan, Skyjo…';

  @override
  String get noPlayersRecorded => 'No players recorded';

  @override
  String get addPlayer => 'Add player';

  @override
  String deletePlayerQuestion(String name) {
    return 'Delete $name?';
  }

  @override
  String get duplicateName => 'This name already exists';

  @override
  String get playerNameHint => 'Player name';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '1 game',
    );
    return '$_temp0';
  }

  @override
  String winsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wins',
      one: '1 win',
    );
    return '$_temp0';
  }

  @override
  String get genericGame => 'Generic game';

  @override
  String get farawayGame => 'Faraway';

  @override
  String get gamesPlayed => 'Games played';

  @override
  String get wins => 'Wins';

  @override
  String get averageScore => 'Average score';

  @override
  String get bestScore => 'Best score';

  @override
  String get worstScore => 'Worst score';

  @override
  String get noFinishedGame => 'No finished games';

  @override
  String get victoryType => 'Victory type';

  @override
  String get highestScore => 'Highest score';

  @override
  String get lowestScore => 'Lowest score';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System';

  @override
  String gameFromDate(String date) {
    return 'Game from $date';
  }
}

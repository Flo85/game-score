import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Score'**
  String get appTitle;

  /// No description provided for @chooseGame.
  ///
  /// In en, this message translates to:
  /// **'Choose a game'**
  String get chooseGame;

  /// No description provided for @freeGame.
  ///
  /// In en, this message translates to:
  /// **'Free game'**
  String get freeGame;

  /// No description provided for @freeGameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Round scores, any game'**
  String get freeGameSubtitle;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @playerBook.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playerBook;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get newGame;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorMessage(String message);

  /// No description provided for @irreversible.
  ///
  /// In en, this message translates to:
  /// **'This action is irreversible.'**
  String get irreversible;

  /// No description provided for @noGamesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No games recorded'**
  String get noGamesRecorded;

  /// No description provided for @deleteGameQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete game?'**
  String get deleteGameQuestion;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **' — in progress'**
  String get inProgress;

  /// No description provided for @playersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 player} other{{count} players}}'**
  String playersCount(int count);

  /// No description provided for @importJson.
  ///
  /// In en, this message translates to:
  /// **'Import JSON'**
  String get importJson;

  /// No description provided for @exportJson.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportJson;

  /// No description provided for @importedGames.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 game imported} other{{count} games imported}}'**
  String importedGames(int count);

  /// No description provided for @noNewGame.
  ///
  /// In en, this message translates to:
  /// **'No new game to import'**
  String get noNewGame;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import error: {error}'**
  String importError(String error);

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved to Downloads'**
  String get fileSaved;

  /// No description provided for @noGameToExport.
  ///
  /// In en, this message translates to:
  /// **'No game to export'**
  String get noGameToExport;

  /// No description provided for @scoreSheet.
  ///
  /// In en, this message translates to:
  /// **'Score sheet'**
  String get scoreSheet;

  /// No description provided for @gameEnded.
  ///
  /// In en, this message translates to:
  /// **'Game ended'**
  String get gameEnded;

  /// No description provided for @totalAbbrev.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get totalAbbrev;

  /// No description provided for @roundAbbrev.
  ///
  /// In en, this message translates to:
  /// **'Rnd'**
  String get roundAbbrev;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @roundLabel.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get roundLabel;

  /// No description provided for @endGameQuestion.
  ///
  /// In en, this message translates to:
  /// **'End game?'**
  String get endGameQuestion;

  /// No description provided for @scoresLocked.
  ///
  /// In en, this message translates to:
  /// **'Scores can no longer be modified.'**
  String get scoresLocked;

  /// No description provided for @endGame.
  ///
  /// In en, this message translates to:
  /// **'End game'**
  String get endGame;

  /// No description provided for @endGameAction.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endGameAction;

  /// No description provided for @maxPlayers.
  ///
  /// In en, this message translates to:
  /// **'Maximum 7 players'**
  String get maxPlayers;

  /// No description provided for @playerIndex.
  ///
  /// In en, this message translates to:
  /// **'Player {index}'**
  String playerIndex(int index);

  /// No description provided for @gameName.
  ///
  /// In en, this message translates to:
  /// **'Game name'**
  String get gameName;

  /// No description provided for @gameNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Uno, Catan, Skyjo…'**
  String get gameNameHint;

  /// No description provided for @noPlayersRecorded.
  ///
  /// In en, this message translates to:
  /// **'No players recorded'**
  String get noPlayersRecorded;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get addPlayer;

  /// No description provided for @deletePlayerQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deletePlayerQuestion(String name);

  /// No description provided for @duplicateName.
  ///
  /// In en, this message translates to:
  /// **'This name already exists'**
  String get duplicateName;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get playerNameHint;

  /// No description provided for @gamesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 game} other{{count} games}}'**
  String gamesCount(int count);

  /// No description provided for @winsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 win} other{{count} wins}}'**
  String winsCount(int count);

  /// No description provided for @genericGame.
  ///
  /// In en, this message translates to:
  /// **'Generic game'**
  String get genericGame;

  /// No description provided for @farawayGame.
  ///
  /// In en, this message translates to:
  /// **'Faraway'**
  String get farawayGame;

  /// No description provided for @gamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'Games played'**
  String get gamesPlayed;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @averageScore.
  ///
  /// In en, this message translates to:
  /// **'Average score'**
  String get averageScore;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get bestScore;

  /// No description provided for @worstScore.
  ///
  /// In en, this message translates to:
  /// **'Worst score'**
  String get worstScore;

  /// No description provided for @noFinishedGame.
  ///
  /// In en, this message translates to:
  /// **'No finished games'**
  String get noFinishedGame;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemLanguage;

  /// No description provided for @gameFromDate.
  ///
  /// In en, this message translates to:
  /// **'Game from {date}'**
  String gameFromDate(String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

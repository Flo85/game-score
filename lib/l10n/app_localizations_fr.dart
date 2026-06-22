// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Game Score';

  @override
  String get chooseGame => 'Choisissez un jeu';

  @override
  String get freeGame => 'Jeu libre';

  @override
  String get freeGameSubtitle => 'Score par manche, n\'importe quel jeu';

  @override
  String get history => 'Historique';

  @override
  String get playerBook => 'Carnet de joueurs';

  @override
  String get newGame => 'Nouvelle partie';

  @override
  String get start => 'Commencer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get add => 'Ajouter';

  @override
  String get rename => 'Renommer';

  @override
  String errorMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get irreversible => 'Cette action est irréversible.';

  @override
  String get noGamesRecorded => 'Aucune partie enregistrée';

  @override
  String get deleteGameQuestion => 'Supprimer la partie ?';

  @override
  String get inProgress => ' — en cours';

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs',
      one: '1 joueur',
    );
    return '$_temp0';
  }

  @override
  String get importJson => 'Importer un JSON';

  @override
  String get exportJson => 'Exporter en JSON';

  @override
  String importedGames(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties importées',
      one: '1 partie importée',
    );
    return '$_temp0';
  }

  @override
  String get noNewGame => 'Aucune nouvelle partie à importer';

  @override
  String importError(String error) {
    return 'Erreur lors de l\'import : $error';
  }

  @override
  String get fileSaved => 'Fichier enregistré dans Téléchargements';

  @override
  String get noGameToExport => 'Aucune partie à exporter';

  @override
  String get scoreSheet => 'Feuille de score';

  @override
  String get gameEnded => 'Partie terminée';

  @override
  String get totalAbbrev => 'T';

  @override
  String get roundAbbrev => 'M.';

  @override
  String get totalLabel => 'Total';

  @override
  String get roundLabel => 'Manche';

  @override
  String get endGameQuestion => 'Terminer la partie ?';

  @override
  String get scoresLocked => 'Les scores ne pourront plus être modifiés.';

  @override
  String get endGame => 'Terminer la partie';

  @override
  String get endGameAction => 'Terminer';

  @override
  String get maxPlayers => 'Maximum de 7 joueurs';

  @override
  String playerIndex(int index) {
    return 'Joueur $index';
  }

  @override
  String get gameName => 'Nom du jeu';

  @override
  String get gameNameHint => 'ex : Uno, Catan, Skyjo…';

  @override
  String get noPlayersRecorded => 'Aucun joueur enregistré';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String deletePlayerQuestion(String name) {
    return 'Supprimer $name ?';
  }

  @override
  String get duplicateName => 'Ce nom existe déjà dans le carnet';

  @override
  String get playerNameHint => 'Nom du joueur';

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parties',
      one: '1 partie',
    );
    return '$_temp0';
  }

  @override
  String winsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victoires',
      one: '1 victoire',
    );
    return '$_temp0';
  }

  @override
  String get genericGame => 'Jeu générique';

  @override
  String get farawayGame => 'Faraway';

  @override
  String get gamesPlayed => 'Parties jouées';

  @override
  String get wins => 'Victoires';

  @override
  String get averageScore => 'Score moyen';

  @override
  String get bestScore => 'Meilleur score';

  @override
  String get worstScore => 'Pire score';

  @override
  String get noFinishedGame => 'Aucune partie terminée';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Système';

  @override
  String gameFromDate(String date) {
    return 'Partie du $date';
  }
}

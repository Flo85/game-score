# Game Score

Application mobile Android de suivi de scores pour jeux de société, développée en Flutter.

## Fonctionnalités

- **Faraway** — feuille de score dédiée au jeu de cartes Faraway (9 lignes, sanctuaire, icônes du jeu)
- **Jeu libre** — suivi de scores par manche pour n'importe quel jeu, nombre de manches illimité
- **Carnet de joueurs** — sauvegarde des joueurs fréquents avec autocomplétion à la création de partie
- **Historique** — consultation et suppression des parties passées par type de jeu
- **Export JSON** — export de l'historique Faraway dans le dossier Téléchargements

## Stack technique

- **Flutter** 3.x / Dart
- **Riverpod** (riverpod_annotation + riverpod_generator) — gestion d'état
- **Drift** (drift_flutter) — base de données SQLite locale
- **path_provider** — accès au système de fichiers

## Structure du projet

```
lib/
├── core/
│   ├── database/        # Schéma Drift et méthodes DB
│   └── models/          # Modèles partagés (Player)
├── features/
│   ├── faraway/         # Jeu Faraway (domain, data, presentation)
│   └── generic/         # Jeu libre (domain, data, presentation)
└── presentation/
    └── screens/         # Écran d'accueil
```

## Base de données

| Table | Colonnes |
|---|---|
| `games` | `id`, `created_at`, `game_type`, `name`, `finished` |
| `game_players` | `game_id`, `player_id`, `player_name`, `position`, `scores_json` |
| `saved_players` | `id`, `name` |

## Lancer le projet

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Build release

Le workflow GitHub Actions `.github/workflows/android.yml` génère automatiquement un APK signé à chaque push sur `main`. Les secrets à configurer dans le dépôt :

| Secret | Description |
|---|---|
| `ANDROID_KEYSTORE` | Keystore encodé en base64 |
| `ANDROID_KEY_ALIAS` | Alias de la clé |
| `ANDROID_KEYSTORE_PASSWORD` | Mot de passe du keystore |
| `ANDROID_KEY_PASSWORD` | Mot de passe de la clé |

Pour générer le keystore, utiliser le workflow `generate-keystore.yml` (déclenchement manuel).

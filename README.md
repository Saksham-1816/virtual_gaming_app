# Virtual Gaming App

## Overview

This Flutter app is a small, feature-focused gaming demo that includes:

- Authentication and multi-user session handling
- Per-user wallets and bet history
- Two games (Dice, Coin Flip)
- Simple provably-fair seed recording for auditability
- Provider-based state management and shared preferences persistence

The repository is intended for assessment and demonstration purposes — not production use.

**Quick start:**

```bash
cd virtual_gaming_app
flutter pub get
flutter run
```

## Features

- **Authentication:** Sign up / login and session switching (per-user data).
- **Wallets:** Per-user balances persisted via `StorageService` (shared_preferences).
- **Games:** Dice and Coin Flip (both support betting and record bet history).
- **Provably-fair:** Server/client seeds and serverSeedHash stored with each bet for audit.
- **History:** Per-user bet history; Home screen previews and a dedicated History screen.
- **Concurrency protections:** Wallet writes serialized per-user and UI guards to prevent double-spend on rapid taps.
- **Unit tests:** Provably-fair and WalletController concurrency tests included.

## Which games are complete vs. partial

- **Dice:** Complete — betting flow, payoffs, history recording, provably-fair seed support.
- **Coin Flip:** Complete — mirrors Dice behavior (choose heads/tails, bet, record, provably-fair).
- **Other games / features:** Partially implemented or placeholder UI only.

## Tech stack

- Flutter / Dart
- State management: `provider` (`ChangeNotifier` providers and controllers)
- Persistence: `shared_preferences` (wrapped by `StorageService`)
- Tests: `flutter_test`
- Crypto: `crypto` package used for HMAC/SHA256 provably-fair helper

## Architecture and design decisions

- **Feature separation:** UI, providers (UI state), controllers (business logic), services (persistence), and models are separated for clarity and testability.
- **State management:** `provider` + `ChangeNotifier` for lightweight, testable state updates.
- **Persistence:** `StorageService` centralizes reads/writes to `SharedPreferences` using per-user keys (e.g. `wallet_<userId>`, `bets_<userId>`).
- **Wallet consistency:** All wallet mutations (add/deduct) use a per-user serialized queue (`WalletController._runExclusive`) to avoid concurrent writes. Additionally, UI-level guards (`_isPlaying` flags) prevent duplicate bets from rapid taps.
- **Provably-fair:** Each bet stores `serverSeed`, `clientSeed`, and `serverSeedHash`. Server seed freshness and hash allow independent verification of outcomes using the HMAC-SHA256 helper in `lib/utils/provably_fair.dart`.
- **History refresh:** The Home screen no longer auto-loads history on init; history is refreshed after navigation returns from a game screen to avoid unwanted loads on app start.

## Folder structure

```
virtual_gaming_app/
│
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
│
├── lib/
│   │
│   ├── app.dart
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── utils/
│   │   └── widgets/
│   │
│   ├── features/
│   │   │
│   │   ├── auth/
│   │   │   ├── model/
│   │   │   ├── repository/
│   │   │   ├── view/
│   │   │   ├── viewmodel/
│   │   │   └── widgets/
│   │   │
│   │   ├── home/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   │
│   │   ├── navigation/
│   │   └── splash/
│   │
│   ├── games/
│   │   ├── dice_game.dart
│   │   └── coin_flip_game.dart
│   │
│   ├── models/
│   │   ├── bet/
│   │   ├── wallet_model/
│   │   └── game/
│   │
│   ├── providers/
│   │   ├── auth/
│   │   ├── wallet/
│   │   ├── dice/
│   │   ├── coin/
│   │   └── history/
│   │
│   ├── services/
│   │   └── storage_service.dart
│   │
│   ├── utils/
│   │   └── provably_fair.dart
│   │
│   └── view/
│       ├── home/
│       ├── history/
│       ├── dice/
│       └── coin/
│
├── test/
│   ├── provably_fair_test.dart
│   ├── wallet_controller_test.dart
│   └── widget_test.dart
│
├── pubspec.yaml
└── README.md
```

## Setup Instructions

1. Clone the repository.
2. Make sure Flutter is installed and available on your machine.
3. Run the dependency install command:

```bash
flutter pub get
```

4. Create or update the `.env` file in the project root.
5. Add your API base URL in the `.env` file (if your app uses an API):

```
API_BASE_URL=http://your-api-url/api/
```

6. Run the app:

```bash
flutter run
```

### API Configuration

If your project integrates with a backend, the `.env` file is used to point the app at the correct API endpoint. The `.env` file is intentionally gitignored so you can keep environment-specific settings private.

If you need machine-readable test output for CI, run:

```bash
flutter test --machine > test-results.json
```


## Tests and full logs

Run tests with expanded logs to capture full debug output in console:

```bash
cd virtual_gaming_app
flutter test -r expanded
```

This prints per-test lines and full runner output (useful for CI or debugging). The repo includes:

- `test/provably_fair_test.dart`
- `test/wallet_controller_test.dart`
- `test/widget_test.dart`

If you want machine-readable output (JSON) for CI, use:

```bash
flutter test --machine > test-results.json
```

## Adding a debug APK (GitHub releases)

To publish an APK and let this README link to it, create a GitHub release and attach the built APK:

1. Build a debug/release APK locally:

```bash
cd virtual_gaming_app
flutter build apk --debug   # or --release
```

2. Create a GitHub release and upload the `build/app/outputs/flutter-apk/app-debug.apk` (or release APK) as a release asset.

3. Add the release download link to this README under **APK Download**.

## What I'd do with more time

- Add real server-side seed commitment (store only hash server-side before revealing serverSeed).
- Integrate real monetization / in-app purchases and secure top-up flows.
- Add E2E tests and integration tests (Widget + integration test harness).
- Harden persistence for offline use and migrate to encrypted storage for wallet seeds.
- Add CI that runs `flutter analyze`, `flutter test -r expanded`, and publishes artifacts.

## Files of interest

- `lib/services/storage_service.dart` — persistence and per-user keying.
- `lib/controllers/wallet_controller/wallet_controller.dart` — wallet operations and serialization.
- `lib/utils/provably_fair.dart` — HMAC-based deterministic roll helper.
- `lib/view/home/home_screen.dart` — history preview and navigation hooks.
- `test/` — unit tests and examples of running tests.
--------------------------------------------------------------------------------
## APk
## 📱 Download APK

[![Download APK](https://img.shields.io/badge/⬇️%20Download%20APK-4CAF50?style=for-the-badge&logo=android&logoColor=white)](https://github.com/Saksham-1816/virtual_gaming_app/releases/tag/build)


## Author

Developed by Dev Saksham-1816.

If you want, I can also:

- Create a `RELEASE_INSTRUCTIONS.md` with step-by-step APK upload and example release notes.
- Add a small `screenshots/` folder and update README image links when you upload screenshots or an APK to GitHub releases.

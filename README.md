# Balloon Smash Adventure

A production-oriented Flutter game scaffold using Flame for gameplay, GetX for
app state, GetStorage for local cache, and Firebase for auth, profiles, storage,
and leaderboard sync.

## Initial Version

This first commit includes the core project structure, playable balloon tap
gameplay, score tracking, profile and leaderboard screens, Google auth wiring,
Firebase repositories, local cache support, and VS Code configuration for
Flutter 3.44.

## Stack

- Flutter 3.44
- Flame 1.37.0+
- GetX 4.7.3
- GetStorage 2.1.1
- Firebase Core, Auth, Firestore, Storage
- Google Sign-In
- Image Picker for profile uploads

## Architecture

```text
lib/
  app/                 App bootstrap, theme, root routing
  core/
    cache/             GetStorage cache adapter
    firebase/          Firebase options and readiness guard
  features/
    auth/              Google auth repository, controller, login UI
    game/              Flame game and play screen
    home/              Flutter home shell
    leaderboard/       Firestore leaderboard repository, controller, UI
    profile/           Player profile model, repository, controller, UI
```

Flame owns gameplay and rendering. Flutter owns app navigation, auth, profile
editing, and leaderboard UI. Firebase is the source of truth; GetStorage caches
profile, best score, and leaderboard snapshots for resilient startup.

## Firebase Setup

1. Create a Firebase project.
2. Enable Authentication with Google Sign-In.
3. Create Firestore and Firebase Storage.
4. Install FlutterFire CLI and run:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Replace `lib/core/firebase/firebase_options.dart` with the generated options.
6. Add generated platform config files, such as `google-services.json` and
   `GoogleService-Info.plist`, where FlutterFire instructs.

## Collections

- `players/{uid}` stores profile, stats, and profile image URL.
- `leaderboard/{uid}` stores denormalized best score rows for fast ranking queries.

## Run

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Guest login is intentionally represented as a disabled UI path so it can be added
later without reshaping the auth surface.

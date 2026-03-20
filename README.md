# Todo List App

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A robust To-Do List application built with Flutter, featuring Firebase Authentication, Realtime Database, and state management using **BLoC** and **formz**.  
Generated with the [Very Good CLI][very_good_cli_link] 🤖, this project follows industry best practices for clean architecture and scalability.

---

## ✨ Features

- **User Authentication** – Email/Password sign‑up and login via Firebase Authentication (Google Sign‑In optional).
- **Task Management** – Create, read, update, delete, and mark tasks as completed.
- **Realtime Sync** – Tasks are stored in Firebase Realtime Database and update across devices instantly.
- **State Management** – BLoC for authentication and task state; `formz` for reactive form validation.
- **Responsive UI** – Adapts to different screen sizes (phone, tablet) using `LayoutBuilder` and flexible widgets.
- **Multi‑flavor Support** – Development, staging, and production environments.

---
## App Link : https://drive.google.com/file/d/1mfNQfolIQpd-zxgu_40EFStgQXK345FC/view?usp=sharing

---
## 🛠️ Tech Stack

- **Flutter** – UI toolkit
- **Firebase** – Auth, Realtime Database
- **BLoC** – State management
- **formz** – Form input validation
- **Very Good CLI** – Project scaffolding and analysis

---

## 📁 Project Structure

The project follows a **feature‑first** approach inside `lib/`:

```
lib/
├── app/                     # App widget and routing
├── auth/                    # Authentication feature
│   ├── bloc/                # AuthBloc, events, states
│   ├── repository/          # AuthRepository (FirebaseAuth)
│   ├── view/                # LoginPage, SignUpPage
│   └── validation/          # EmailInput, PasswordInput (formz)
├── core/                    # Shared constants (AppColors)
├── tasks/                    # Task management feature
│   ├── bloc/                # TaskBloc, events, states
│   ├── model/               # Task entity
│   ├── repository/          # TaskRepository (Realtime Database)
│   ├── view/                # HomePage, AddEditTaskPage
│   │   └── widgets/         # TaskTile
│   └── validation/          # TitleInput, DescriptionInput (formz)
├── l10n/                     # Localization (optional)
├── bootstrap.dart            # Firebase initialization and app bootstrap
└── main_*.dart               # Entry points for each flavor
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (≥3.0)
- A Firebase project (follow steps below)

### Firebase Setup

1. Create a Firebase project in the [Firebase Console](https://console.firebase.google.com).
2. Enable **Email/Password** authentication under **Authentication → Sign‑in method**.
3. Create a **Realtime Database** and set rules to allow authenticated access:
   ```json
   {
     "rules": {
       "users": {
         "$uid": {
           ".read": "$uid === auth.uid",
           ".write": "$uid === auth.uid"
         }
       }
     }
   }
   ```
4. Register your Android/iOS app and download the config files (`google-services.json` / `GoogleService-Info.plist`).
5. Install the Firebase CLI and run `flutterfire configure` in the project root to generate `lib/firebase_options.dart`.

### Running the App

This project uses **flavors** (development, staging, production).  
Choose the appropriate command based on your target environment:

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

If you are using an IDE (VS Code / Android Studio), launch configurations are also available.

---

## 📦 Building the APK

To generate a release APK (for submission):

```bash
flutter clean
flutter pub get
flutter build apk --release --flavor production --target lib/main_production.dart
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`. Rename it to `TodoApp_Herody.apk`.

---

## 🧪 Testing

Run unit and widget tests with coverage:

```bash
very_good test --coverage --test-randomize-ordering-seed random
```

Generate a coverage report:

```bash
genhtml coverage/lcov.info -o coverage/
open coverage/index.html   # macOS
```

---

## 🔍 BLoC Linting

This project uses [bloc_lint](https://pub.dev/packages/bloc_lint) to enforce BLoC best practices:

```bash
dart run bloc_tools:bloc lint .
```

---

## 🌐 Localization (Optional)

Localization strings are managed in `lib/l10n/arb/`.  
To generate the localization files, run:

```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli

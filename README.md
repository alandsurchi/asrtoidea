
#  Flutter
A modern Flutter-based mobile application utilizing the latest mobile development technologies and tools for building responsive cross-platform applications.
## 📋 Prerequisites
- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)
## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

### Web Development Session Persistence (Important)
When running with `flutter run -d chrome`, browser storage may reset between runs,
which can make saved login sessions appear lost.

Use this command to keep a fixed Chrome profile (and keep your auth token/session):
```bash
flutter run -d chrome --web-port 7357 --web-browser-flag="--user-data-dir=%USERPROFILE%\\AppData\\Local\\ai_idea_generator_chrome_profile"
```

Or run one of these VS Code tasks:
- `Flutter Web (Persistent Chrome Profile)`
- `Flutter Web (Auto Free 7357 + Persistent Profile)` (recommended on Windows; clears stale port usage first)

### Railway Auth + Explore Verification
Use this script to verify three core behaviors on Railway:
- Profile data is account-specific
- Ideas are private per account
- Explore feed is global across accounts

Run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify_railway_auth_explore.ps1
```

If Explore is still not global, deploy the latest backend changes first, then rerun the script.

### Railway Backend Deploy (Do this to avoid Flutter build errors)
If Railway is connected to this repository root by mistake, it may try to build Flutter web for the backend service and fail.

This repo now includes a root fallback (`railway.json` + `nixpacks.toml`) that runs backend commands, but you should still keep the Railway service root directory as `backend`.

Recommended deploy command:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\deploy_backend_railway.ps1
```

This script deploys from `backend/` and prints Railway service status afterward.

### CI and Quality Gates
The repository now includes GitHub Actions workflows:
- `.github/workflows/ci.yml`
  - Flutter analyze + tests
  - Backend integration tests (Jest + Supertest + Postgres service)
- `.github/workflows/post-deploy-verify.yml`
  - Runs production verification script after successful CI on `main`
  - Fails workflow and emits an optional webhook alert when verification fails

In Railway production settings, enable **Wait for CI** so production deploys only start after CI passes.

Optional: add GitHub Actions secret `RAILWAY_ALERT_WEBHOOK_URL` to send failure alerts to Slack/Discord/Teams-compatible incoming webhook endpoints.

### Public Web Deployment (Free via Vercel)
Frontend is now deployed publicly on Vercel.

Current live link:
https://web-sand-eight-49.vercel.app/

One-command deployment from repo root:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\deploy_web_vercel.ps1
```

VS Code task:
- `Deploy Web to Vercel (Production)`

Automatic deploy status:
- Enabled via GitHub integration (repo: `alandsurchi/asrtoidea`)
- Production branch: `main`
- Any new push to `main` triggers a fresh production deployment automatically

Notes:
- Backend API remains on Railway: `https://asrtoidea-production.up.railway.app/api/v1`
- If prompted by CLI, complete `vercel login` once, then rerun deploy.
## 📁 Project Structure
```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```
## 🧩 Adding Routes
To add new routes to the application, update the `lib/routes/app_routes.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```
## 🎨 Theming

This project includes a comprehensive theming system with both light and dark themes:

```dart
// Access the current theme
ThemeData get theme => ThemeHelper().themeData();

// Use colors
color: theme.colorScheme.primary,
```

## 📱 Responsive Design
The app is built with responsive design using the SizeUtils:

```dart
// Example of responsive sizing
Container(
  width: 50.h,
  height: 20.h,
  child: Text('Responsive Container'),
)
```
## 📦 Deployment
Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🙏 Acknowledgments
- Built with [Rocket.new](https://rocket.new)
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design

Built with ❤️ on Rocket.new


### Fonts
We were unable to find the following Fonts, Please add manually to ```assets/fonts``` 

```
NRTBoldBold.ttf
SFProTextBold.ttf
SFProTextMedium.ttf
```
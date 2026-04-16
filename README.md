# Arohi - Workforce Marketplace

A workforce marketplace mobile app where businesses hire contractors, contractors manage teams of workers, and workers find jobs — built with Flutter.

**Package**: `com.blc.workerapp`

## Prerequisites

| Tool | Version |
|------|---------|
| Flutter | 3.27.3+ (stable) |
| Dart | 3.6.1+ |
| Java | JDK 21 |
| Android SDK | compileSdk managed by Flutter |
| Gradle | 8.9 |
| AGP | 8.5.1 |
| Kotlin | 1.9.24 |

## Setup

```bash
# Clone the repo
git clone <repo-url>
cd worker-app-blc

# Install dependencies
flutter pub get

# Verify setup
flutter doctor
```

## Running the App

```bash
# Debug mode (connected device or emulator)
flutter run

# Debug on a specific device
flutter devices              # list available devices
flutter run -d <device-id>

# Run with verbose logging
flutter run --verbose
```

## Building

### Android APK

```bash
# Debug APK
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk

# Release APK
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Release APK split by ABI (smaller per-device files)
flutter build apk --release --split-per-abi
# Output: build/app/outputs/flutter-apk/
#   app-armeabi-v7a-release.apk   (~15 MB, older phones)
#   app-arm64-v8a-release.apk     (~16 MB, most modern phones)
#   app-x86_64-release.apk        (~16 MB, emulators)
```

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)

```bash
# Requires Xcode and Apple Developer account
flutter build ipa --release
# Output: build/ios/ipa/worker_app_blc.ipa
```

## Installing on Device

### Via Flutter CLI

```bash
# Install on connected device
flutter install
```

### Via ADB (Android)

```bash
adb install build/app/outputs/flutter-apk/app-release.apk

# Replace existing install
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Manual Transfer

1. Copy `build/app/outputs/flutter-apk/app-release.apk` to your phone
2. Open the file on your phone
3. Enable **"Install from unknown sources"** if prompted (Settings > Security)

## Code Quality

```bash
# Static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format lib/
```

## Project Structure

```
lib/
├── main.dart                          # App entry point, ProviderScope + ScreenUtil
└── src/
    ├── core/
    │   ├── theme/
    │   │   ├── colors.dart            # Color palette (primary blue, accent orange)
    │   │   ├── text_styles.dart       # Typography (Poppins headings, Inter body)
    │   │   ├── spacing.dart           # Spacing constants (xs 4 → xxl 48)
    │   │   ├── radius.dart            # Border radius constants
    │   │   ├── shadows.dart           # Box shadow presets
    │   │   └── theme.dart             # ThemeData builder + barrel exports
    │   └── widgets/
    │       ├── primary_button.dart     # Gradient button with loading/icon/size
    │       ├── secondary_button.dart   # Outlined button, same API
    │       ├── app_text.dart           # Semantic text widget (AppText.heading1, .body, etc.)
    │       ├── app_card.dart           # Tappable card with shadow levels
    │       ├── role_scaffold.dart      # Role-based home screen scaffold
    │       ├── search_field.dart       # Search input with filter icon
    │       └── section_header.dart     # Section title + action link
    ├── router/
    │   └── app_router.dart            # GoRouter config, auth-based redirects
    └── features/
        ├── splash/                    # Splash screen (animated Arohi branding)
        ├── onboarding/                # 3-screen onboarding PageView
        │   └── presentation/
        │       ├── onboarding_screen.dart
        │       └── widgets/
        │           ├── onboarding_illustration.dart  # CustomPainter illustrations
        │           └── page_indicator.dart
        ├── auth/                      # Phone + OTP authentication
        ├── region/                    # City/region selection
        ├── role/                      # Role selection (Employer/Worker/Customer)
        ├── profile/                   # Profile completion
        ├── employer/                  # Employer home + post job
        ├── worker/                    # Worker home (job search)
        ├── customer/                  # Customer home
        ├── jobs/                      # Job list + detail screens
        ├── applications/              # Job applications
        └── directory/                 # Worker directory + cards
```

## App Flow

```
Splash → Onboarding (first launch only) → Phone Auth → OTP → Region → Role → Profile → Home
```

Three role-based home screens after onboarding:
- **Employer**: Post jobs, view applications, manage listings
- **Worker**: Browse jobs, apply, track applications
- **Customer**: Browse workforce directory

## Design System

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#2563EB` | Buttons, links, active states |
| `primaryDark` | `#1D4ED8` | Gradients, pressed states |
| `primaryLight` | `#60A5FA` | Highlights, badges |
| `accent` | `#F59E0B` | CTAs, alerts, emphasis |
| `background` | `#F8FAFC` | Screen backgrounds |
| `surface` | `#FFFFFF` | Cards, inputs |
| `textPrimary` | `#0F172A` | Headings, body text |
| `textSecondary` | `#475569` | Captions, subtitles |
| `textMuted` | `#94A3B8` | Hints, placeholders |

### Typography

- **Headings**: Poppins (600–700 weight)
- **Body/UI**: Inter (400–600 weight)
- Applied globally via `google_fonts` package — no font files bundled

### Reusable Components

```dart
// Buttons
PrimaryButton(label: 'Submit', onPressed: _submit, isLoading: true)
SecondaryButton(label: 'Cancel', onPressed: _cancel, icon: Icons.close)

// Text
AppText.heading1('Welcome')
AppText.body('Description', color: AppColors.textSecondary)

// Card
AppCard(
  shadow: AppCardShadow.card,
  onTap: () {},
  child: Text('Content'),
)
```

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing with auth redirects |
| `flutter_screenutil` | Responsive sizing (design: 390x844) |
| `google_fonts` | Inter + Poppins typography |
| `dio` | HTTP networking |
| `shared_preferences` | Local key-value storage |
| `geolocator` / `geocoding` | Location services |
| `google_maps_flutter` | Map views |
| `cached_network_image` | Image loading + caching |
| `pin_code_fields` | OTP input UI |
| `shimmer` | Loading skeleton effects |
| `fluttertoast` | Toast notifications |

## Android Configuration

- **Namespace**: `com.blc.workerapp`
- **Min SDK**: Managed by Flutter
- **Gradle**: 8.9
- **AGP**: 8.5.1
- **Kotlin**: 1.9.24
- **Jetifier**: Disabled (pure AndroidX)
- **Signing**: Debug keys (release signing config TBD)

### Release Signing (TODO)

To sign release builds for Play Store distribution:

1. Generate a keystore:
   ```bash
   keytool -genkey -v -keystore ~/arohi-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias arohi
   ```

2. Create `android/key.properties`:
   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=arohi
   storeFile=<path-to>/arohi-release.jks
   ```

3. Update `android/app/build.gradle` to reference the signing config.

## Versioning

Version is set in `pubspec.yaml`:

```yaml
version: 1.0.0+1
#         ^^^^^  ^
#         name   build number
```

To bump version for a new release:

```bash
# Edit pubspec.yaml, then build
flutter build apk --release --build-name=1.1.0 --build-number=2
```

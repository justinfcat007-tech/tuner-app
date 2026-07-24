# Tuner App - Flutter

Guitar, Ukulele, and Yangqin tuner built with Flutter.

## Requirements

- Flutter 3.27+ (stable)
- Dart 3.8+
- Android SDK 24+
- Xcode 15+ (iOS)

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run tests
flutter test

# Build debug APK
flutter build apk --debug
```

## Configuration

### API Base URL

Use `--dart-define` for API configuration:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:8080/api
```

### Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

### iOS Permissions

Add to `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is needed for real-time pitch detection.</string>
```

## Testing

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test integration_test/
```

## Architecture

See [docs/architecture.md](docs/architecture.md) for details.

## License

Proprietary - All rights reserved.

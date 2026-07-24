# Tuner App Flutter - Architecture

## Overview

Flutter rewrite of the existing Vue 3 + TypeScript tuner application.
Provides guitar, ukulele, and yangqin tuning with native audio processing.

## Tech Stack

- **Flutter**: Stable channel
- **Dart**: 3.8+
- **State Management**: Riverpod
- **Routing**: go_router
- **HTTP**: Dio
- **Storage**: shared_preferences, flutter_secure_storage
- **Audio**: Native platform channels (Kotlin/Android)

## Directory Structure

```
lib/
  app/           - App config, theme, router
  core/          - Cross-cutting concerns
    audio/       - Audio engine interface
    network/     - API client
    storage/     - Local preferences
    permissions/ - Permission handling
    utils/       - Utilities
  features/      - Feature modules
    home/        - Instrument selector
    tuner/       - Shared tuner logic
    guitar/      - Guitar tuner
    ukulele/     - Ukulele tuner
    yangqin/     - Yangqin tuner
    tuning_library/
    auth/
    profile/
    orders/
    pro/
    privacy/
    support/
  shared/        - Shared widgets and models
```

## Architecture Principles

1. **Feature-first organization**: Each feature contains domain, data, application, and presentation layers
2. **Native audio**: DSP runs on native threads, not Flutter UI isolate
3. **Riverpod for DI**: All dependencies injected via providers
4. **Testable**: DSP algorithms have unit tests with synthetic signals
5. **No WebView**: All UI is native Flutter widgets

## Audio Pipeline

```
Microphone → AudioRecord (native) → YIN/pYIN (native) → EventChannel → Dart Stream → UI
```

- PCM samples never cross the platform boundary
- Only pitch results (10-20 Hz) are sent to Dart
- Filtering and stabilization happen on native side

## Migration from Vue

See [migration-map.md](./migration-map.md) for feature mapping.

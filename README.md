# Kurdistan IPTV (Flutter)

## Files included
- `pubspec.yaml` — Flutter dependencies
- `lib/main.dart` — app UI, channel list, search, favorites, HLS player, settings
- `android/app/src/main/AndroidManifest.xml` — Internet permission and cleartext support for legacy HTTP streams

## Build
1. Create/open a Flutter project in your mobile IDE.
2. Replace `pubspec.yaml`, `lib/main.dart`, and `android/app/src/main/AndroidManifest.xml` with these files. Keep the rest of the standard Flutter Android project files (Gradle files, `MainActivity.kt`, styles, launcher icons).
3. Run `flutter pub get`.
4. Run `flutter run`, or build using `flutter build apk --release`.
5. APK output: `build/app/outputs/flutter-apk/app-release.apk`.

## Add streams
In `lib/main.dart`, add entries inside `channels`, following:
`TvChannel('Channel Name', 'https://provider.example/live.m3u8', group: 'News'),`
Available groups: `Kurdish`, `News`, `Arabic`, `Sports`, `Kids`, `Family`, `International`.

Use only streams you are authorized to access. Playback cannot be guaranteed for every URL; providers can be offline, geo-blocked, or require headers/DRM. This project uses Flutter's `video_player` plugin and HLS support provided by Android's media stack.

# opensubtitles_hash
Simple Dart hashing library for [OpenSubtitles](https://www.opensubtitles.org/).


## Usage
To hash a local file:
```dart
String hash = await OpenSubtitlesHasher.computeFileHash(
  new File('breakdance.avi')
);
```

To hash a remote file (HTTP):
```dart
String hash = await OpenSubtitlesHasher.computeURLHash(
  "http://www.opensubtitles.org/addons/avi/breakdance.avi",
  headers: { "X-My-Header": "true" }, // (Optional)
  followRedirects: false              // (Optional)
);
```

## Testing
Simply use `pub run test test.dart` to test that the library functions correctly.

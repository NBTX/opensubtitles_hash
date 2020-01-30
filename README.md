# opensubtitles_hash
Dart 2 hashing library for [OpenSubtitles](https://www.opensubtitles.org/).

This package is used to calculate OpenSubtitles' hash for video files in order to search for subtitles for that file in OpenSubtitles' database.

More information about the hashing process can be found here: https://trac.opensubtitles.org/projects/opensubtitles/wiki/HashSourceCodes

## Usage
To hash a local file:
```dart
// File is the sample AVI file from the HashSourceCodes page
// on OpenSubtitle's Wiki.
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

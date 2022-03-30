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

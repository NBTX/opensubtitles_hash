import 'dart:io';

import "package:test/test.dart";
import "opensubtitles_hash.dart";

void main() {
  test("Correctly hashes ./breakdance.avi", () async {
    expect(await OpenSubtitlesHasher.computeFileHash(
      new File('./breakdance.avi')
    ), equals("8e245d9679d31e12"));
  });

  test("Correctly hashes HTTP breakdance.avi file", () async {
    expect(await OpenSubtitlesHasher.computeURLHash(
      "http://www.opensubtitles.org/addons/avi/breakdance.avi"
    ), equals("8e245d9679d31e12"));
  });
}

///
/// Copyright 2019 SamJakob (NBTX, ApolloTV)
///
/// Permission is hereby granted, free of charge, to any person
/// obtaining a copy of this software and associated documentation
/// files (the "Software"), to deal in the Software without
/// restriction, including without limitation the rights to use,
/// copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom the
/// Software is furnished to do so, subject to the following
/// conditions:
///
/// The above copyright notice and this permission notice shall be
/// included in all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
/// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
/// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
/// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
/// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
/// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
/// OTHER DEALINGS IN THE SOFTWARE.

library opensubtitles_hash;

import 'dart:async';
import 'dart:io';

///
/// Simple Dart implementation of the OpenSubtitles hash algorithm.
///
/// Hash code is based on Media Player Classic. In natural language
/// it calculates: size + 64bit checksum of the first and last 64k
///
/// (even if they overlap because the file is smaller than
/// * 128k).
///
/// Example Usage:
/// --------------
/// String hash = await OpenSubtitlesHasher.computeFileHash(
///   new File('./breakdance.avi')
/// );
///
/// String hash = await OpenSubtitlesHasher.computeURLHash(
///   "http://www.opensubtitles.org/addons/avi/breakdance.avi"
/// )
///
class OpenSubtitlesHasher {
  // 64 * 1024
  static const kHashChunkSize = 65536;

  static Future<String> computeURLHash(String url, {Map<String, dynamic>? headers, bool followRedirects = false}) async {
    HttpClient client = HttpClient();
    HttpClientResponse response;
    response = await client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      // Add headers if they have been provided...
      if (headers != null) {
        headers.forEach((String name, dynamic value) {
          request.headers.add(name, value.toString());
        });
      }

      request.followRedirects = followRedirects;
      return request.close();
    });

    List<List<int>> responseData = await response.toList();
    return await computeHash(responseData.expand((i) => i).toList());
  }

  static Future<String> computeFileHash(File file) async {
    return await computeHash(await file.readAsBytes());
  }

  ///
  /// Computes the hash of the byte array parameter.
  ///
  /// This is used by [computeURLHash] and [computeFileHash].
  ///
  static Future<String> computeHash(List<int> subtitleFile) async {
    List<int> data = List.filled(8, 0, growable: true);

    /// Perform a shift on the first 8 entries
    /// in [data] relative to the size of the file.
    int temp = subtitleFile.length;
    for (var i = 0; i < 8; i++) {
      data[i] = temp & 255;
      temp = temp >> 8;
    }

    /// Read bytes from 0 to [HASH_CHUNK_SIZE]
    /// and add the value to the corresponding
    /// position in [data].
    for (var i = 0; i < kHashChunkSize; i++) {
      data[(i + 8) % 8] += subtitleFile[i];
    }

    /// Read the last [HASH_CHUNK_SIZE] bytes
    /// and add the value to the corresponding
    /// position in [data].
    int startReference = subtitleFile.length - kHashChunkSize;
    for (var i = startReference; i < subtitleFile.length; i++) {
      int fileOffset = i - startReference;
      data[(fileOffset + 8) % 8] += subtitleFile[i];
    }

    return _binl2hex(data);
  }

  static _binl2hex(a) {
    var b = 255, c = 7, d = '0123456789abcdef', e = '';

    a[1] += a[0] >> 8;
    a[0] = a[0] & b;
    a[2] += a[1] >> 8;
    a[1] = a[1] & b;
    a[3] += a[2] >> 8;
    a[2] = a[2] & b;
    a[4] += a[3] >> 8;
    a[3] = a[3] & b;
    a[5] += a[4] >> 8;
    a[4] = a[4] & b;
    a[6] += a[5] >> 8;
    a[5] = a[5] & b;
    a[7] += a[6] >> 8;
    a[6] = a[6] & b;
    a[7] = a[7] & b;
    for (c; c > -1; c--) {
      e += d[(a[c] >> 4 & 15)] + d[(a[c] & 15)];
    }
    return e;
  }
}

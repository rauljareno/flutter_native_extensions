import 'dart:io';
import 'dart:typed_data';

import 'package:collection/equality.dart';
import 'package:test/test.dart';

import 'package:dart_native_compression/dart_native_compression.dart';

import 'setup_util.dart';

void main() async {
  final lz4 = Lz4Lib(lib: await SetupUtil.getDylibAsync());
  test('getVersioinNumber', () {
    final version = lz4.getVersioinNumber();
    print('LZ4 version number: $version');
    assert(version > 0);
  });

  test('getVersionString', () {
    final version = lz4.getVersionString();
    print('LZ4 version string: $version');
    assert(version != null && !version.isEmpty);
  });

  test('getFrameVersionNumber', () {
    final version = lz4.getFrameVersionNumber();
    print('LZ4 frame version: $version');
    assert(version > 0);
  });

  test('getCompressFrameBound', () {
    final bound = lz4.getCompressFrameBound(19);
    print('LZ4 compress frame bound for 19: $bound');
    assert(bound > 0);
  });

  test('E2E', () {
    final src = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 9, 8, 7, 6, 5, 4, 3, 2, 1];
    final compressed = lz4.compressFrame(Uint8List.fromList(src));
    print(compressed);
    assert(compressed.length > 0);
    final decompressed = lz4.decompressFrame(compressed);
    print(decompressed);
    assert(ListEquality().equals(src, decompressed));
  });

  test('E2E_LargeFile', () async {
    final src = await File.fromUri(Uri.file('akrobat.ttf')).readAsBytesSync();
    print('src: ${src.length}');
    final compressed = lz4.compressFrame(Uint8List.fromList(src));
    print('compressed: ${compressed.length}');
    assert(compressed.length > 0);
    final decompressed = lz4.decompressFrame(compressed);
    print('decompressed: ${decompressed.length}');
    assert(ListEquality().equals(src, decompressed));
  });
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFont(String family, String path) async {
  final fontData = File(path).readAsBytesSync();
  final fontLoader = FontLoader(family)
    ..addFont(Future.value(ByteData.sublistView(Uint8List.fromList(fontData))));
  await fontLoader.load();
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await _loadFont('SourceSans3', 'assets/fonts/SourceSans3-VariableFont.ttf');

  await _loadFont('MaterialIcons', _materialIconsPath());

  await testMain();
}

/// Locates the real MaterialIcons font inside whichever SDK is running the
/// tests, so icons render as glyphs in the goldens rather than as boxes.
///
/// Derived from the test runner's own binary — `<sdk>/bin/cache/dart-sdk/bin/dart`
/// — rather than a `.fvm/flutter_sdk` symlink, which current fvm versions do
/// not create and which broke the whole suite when it went away.
String _materialIconsPath() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.path != dir.parent.path) {
    final font = File(
      '${dir.path}/artifacts/material_fonts/MaterialIcons-Regular.otf',
    );
    if (font.existsSync()) return font.path;
    dir = dir.parent;
  }
  throw StateError(
    'MaterialIcons-Regular.otf not found above ${Platform.resolvedExecutable}',
  );
}

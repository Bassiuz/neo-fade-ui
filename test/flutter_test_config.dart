import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFont(String family, String path) async {
  final fontData = File(path).readAsBytesSync();
  final fontLoader = FontLoader(family)
    ..addFont(
        Future.value(ByteData.sublistView(Uint8List.fromList(fontData))));
  await fontLoader.load();
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await _loadFont('SourceSans3', 'assets/fonts/SourceSans3-VariableFont.ttf');

  final flutterSdk = File('.fvm/flutter_sdk').resolveSymbolicLinksSync();
  await _loadFont('MaterialIcons',
      '$flutterSdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf');

  await testMain();
}

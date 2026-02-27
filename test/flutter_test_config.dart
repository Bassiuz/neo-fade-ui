import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fontData =
      File('assets/fonts/SourceSans3-VariableFont.ttf').readAsBytesSync();
  final fontLoader = FontLoader('SourceSans3')
    ..addFont(
        Future.value(ByteData.sublistView(Uint8List.fromList(fontData))));
  await fontLoader.load();

  await testMain();
}

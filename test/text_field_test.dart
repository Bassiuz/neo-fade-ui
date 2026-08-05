import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import 'helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpGoldenWidget(child, size: const Size(400, 200));

  testWidgets('the underline field supports selection, so paste works', (
    tester,
  ) async {
    await pump(tester, NeoTextField.underline(hintText: 'Token'));
    // A bare EditableText has no selection controls and so no long-press
    // menu — which is what stopped a token being pasted on a phone.
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.enableInteractiveSelection ?? true, isTrue);
  });

  testWidgets('the underline field renders its hint', (tester) async {
    await pump(tester, NeoTextField.underline(hintText: 'Token'));
    expect(find.text('Token'), findsOneWidget);
  });

  testWidgets('obscureText still hides the value', (tester) async {
    final controller = TextEditingController(text: 'secret');
    addTearDown(controller.dispose);
    await pump(
      tester,
      NeoTextField.underline(controller: controller, obscureText: true),
    );
    expect(
      tester.widget<TextField>(find.byType(TextField)).obscureText,
      isTrue,
    );
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoCard1 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 300,
          child: NeoCard1(
            child: Text('Card Content'),
          ),
        ),
        size: GoldenTestSizes.card,
      );
      await expectLater(
        find.byType(NeoCard1),
        matchesGoldenFile('neo_card_1_default.png'),
      );
    });

    testWidgets('with rich content', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 300,
          child: NeoCard1(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Card Title',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'This is the card description with multiple lines of content.',
                ),
              ],
            ),
          ),
        ),
        size: GoldenTestSizes.card,
      );
      await expectLater(
        find.byType(NeoCard1),
        matchesGoldenFile('neo_card_1_rich_content.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        const SizedBox(
          width: 300,
          child: NeoCard1(
            child: Text('Card Content'),
          ),
        ),
        size: GoldenTestSizes.card,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoCard1),
        matchesGoldenFile('neo_card_1_dark.png'),
      );
    });
  });

  group('NeoFeatureCard1 Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard1(
          icon: Icons.star,
          title: 'Feature Title',
          subtitle: 'Feature description goes here',
          onTap: () {},
        ),
        size: const Size(250, 180),
      );
      await expectLater(
        find.byType(NeoFeatureCard1),
        matchesGoldenFile('neo_feature_card_1_default.png'),
      );
    });

    testWidgets('without subtitle', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard1(
          icon: Icons.rocket_launch,
          title: 'Quick Action',
          onTap: () {},
        ),
        size: const Size(250, 140),
      );
      await expectLater(
        find.byType(NeoFeatureCard1),
        matchesGoldenFile('neo_feature_card_1_no_subtitle.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard1(
          icon: Icons.star,
          title: 'Feature Title',
          subtitle: 'Feature description goes here',
          onTap: () {},
        ),
        size: const Size(250, 180),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoFeatureCard1),
        matchesGoldenFile('neo_feature_card_1_dark.png'),
      );
    });
  });
}

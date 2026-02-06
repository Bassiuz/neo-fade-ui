import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neo_fade_ui/neo_fade_ui.dart';

import '../helpers/golden_test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpGoldenTests();
  });

  group('NeoCardTopBorder Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoCard.topBorder(
            child: const Text('Card Content'),
          ),
        ),
        size: GoldenTestSizes.card,
      );
      await expectLater(
        find.byType(NeoCardTopBorder),
        matchesGoldenFile('neo_card_1_default.png'),
      );
    });

    testWidgets('with rich content', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoCard.topBorder(
            child: const Column(
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
        find.byType(NeoCardTopBorder),
        matchesGoldenFile('neo_card_1_rich_content.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        SizedBox(
          width: 300,
          child: NeoCard.topBorder(
            child: const Text('Card Content'),
          ),
        ),
        size: GoldenTestSizes.card,
        isDark: true,
      );
      await expectLater(
        find.byType(NeoCardTopBorder),
        matchesGoldenFile('neo_card_1_dark.png'),
      );
    });
  });

  group('NeoFeatureCardIconTop Goldens', () {
    testWidgets('default state', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard.iconTop(
          icon: Icons.star,
          title: 'Feature Title',
          subtitle: 'Feature description goes here',
          onTap: () {},
        ),
        size: const Size(250, 180),
      );
      await expectLater(
        find.byType(NeoFeatureCardIconTop),
        matchesGoldenFile('neo_feature_card_1_default.png'),
      );
    });

    testWidgets('without subtitle', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard.iconTop(
          icon: Icons.rocket_launch,
          title: 'Quick Action',
          onTap: () {},
        ),
        size: const Size(250, 140),
      );
      await expectLater(
        find.byType(NeoFeatureCardIconTop),
        matchesGoldenFile('neo_feature_card_1_no_subtitle.png'),
      );
    });

    testWidgets('dark theme', (tester) async {
      await tester.pumpGoldenWidget(
        NeoFeatureCard.iconTop(
          icon: Icons.star,
          title: 'Feature Title',
          subtitle: 'Feature description goes here',
          onTap: () {},
        ),
        size: const Size(250, 180),
        isDark: true,
      );
      await expectLater(
        find.byType(NeoFeatureCardIconTop),
        matchesGoldenFile('neo_feature_card_1_dark.png'),
      );
    });
  });
}

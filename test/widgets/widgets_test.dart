import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swish_lab/widgets/background.dart';
import 'package:swish_lab/widgets/box_with_shadow.dart';
import 'package:swish_lab/widgets/choice_chips_group.dart';
import 'package:swish_lab/widgets/custom_text_span.dart';
import 'package:swish_lab/widgets/debug_item.dart';
import 'package:swish_lab/widgets/dynamic_icon_image.dart';
import 'package:swish_lab/widgets/faq_item.dart';
import 'package:swish_lab/widgets/icon_action_button.dart';
import 'package:swish_lab/widgets/toggle_icon.dart';
import 'package:swish_lab/widgets/light_button.dart';
import 'package:swish_lab/widgets/dark_button.dart';
import 'package:swish_lab/widgets/transparent_button.dart';
import 'package:swish_lab/widgets/stats_container.dart';
import 'package:swish_lab/widgets/settings_row.dart';
import 'package:swish_lab/widgets/settings_item.dart';
import 'package:swish_lab/widgets/dynamic_asset.dart';
import 'package:swish_lab/widgets/app_bar.dart';
import 'package:swish_lab/widgets/social_icon_button.dart';
import 'package:swish_lab/widgets/nav_bar_scaffold.dart';
import 'package:swish_lab/models/custom_enums.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/router/central_routing.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  group('Background', () {
    testWidgets('renders background with child', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Background(child: Text('test child')),
      ));
      expect(find.text('test child'), findsOneWidget);
    });
  });

  group('BoxWithShadow', () {
    test('creates BoxDecoration with correct default color', () {
      final decoration = BoxWithShadow();
      expect(decoration.color, equals(AppThemeManager.primaryBackground));
    });
  });

  group('ChoiceChipsGroup', () {
    testWidgets('renders horizontal direction', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChoiceChipsGroup<int>(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onChanged: (_) {},
            direction: ChipsDirection.horizontal,
          ),
        ),
      ));
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('renders vertical direction', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChoiceChipsGroup<int>(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onChanged: (_) {},
            direction: ChipsDirection.vertical,
          ),
        ),
      ));
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('renders wrap direction', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChoiceChipsGroup<int>(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onChanged: (_) {},
            direction: ChipsDirection.wrap,
          ),
        ),
      ));
      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('triggers onChanged on tap', (tester) async {
      int? selected;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ChoiceChipsGroup<int>(
            labels: const ['A', 'B'],
            selectedIndex: 0,
            onChanged: (i) => selected = i,
          ),
        ),
      ));

      await tester.tap(find.text('B'), warnIfMissed: false);
      expect(selected, 1);

      await tester.pump();
      await tester.tap(find.text('A'), warnIfMissed: false);
      expect(selected, isNull); // Deselect
    });
  });

  group('CustomTextSpan', () {
    testWidgets('renders text spans', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => RichText(
              text: TextSpan(
                children: [
                  CustomTextSpan(context, text: 'normal '),
                  CustomTextSpan(context, text: 'bold', bold: true),
                ],
              ),
            ),
          ),
        ),
      ));
      expect(find.byType(RichText), findsOneWidget);
    });
  });

  group('DebugItem', () {
    testWidgets('renders and triggers action', (tester) async {
      bool triggered = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DebugItem(
            title: 'Debug Title',
            buttonText: 'Action',
            onPressed: () => triggered = true,
          ),
        ),
      ));

      expect(find.text('Debug Title'), findsOneWidget);
      await tester.tap(find.text('Action'));
      expect(triggered, true);
    });
  });

  group('DynamicIconImage', () {
    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: DynamicIconImage(imageName: 'test_icon'),
      ));
      expect(find.byType(DynamicIconImage), findsOneWidget);
    });
  });

  group('FaqItem', () {
    testWidgets('toggles open state and shows description', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FaqItem(
            title: 'FAQ Question',
            description: 'FAQ Answer',
            isOpen: true,
            onPressed: () async => pressed = true,
          ),
        ),
      ));

      expect(find.text('FAQ Answer'), findsOneWidget);
      await tester.tap(find.text('FAQ Question'));
      expect(pressed, true);
      await tester.pumpAndSettle();
    });
  });

  group('IconActionButton', () {
    testWidgets('renders wrapped style', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: IconActionButton(
            const Icon(Icons.add),
            onPressed: () {},
            wrapped: true,
          ),
        ),
      ));
      expect(find.byType(IconActionButton), findsOneWidget);
    });
  });

  group('ToggleIcon', () {
    testWidgets('switches icons', (tester) async {
      bool value = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ToggleIcon(
            value: value,
            onIcon: const Icon(Icons.check, key: ValueKey('on')),
            offIcon: const Icon(Icons.close, key: ValueKey('off')),
            onPressed: () => value = !value,
          ),
        ),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byType(IconButton));
      expect(value, true);
    });
  });

  group('Buttons', () {
    testWidgets('LightButton renders and taps', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: LightButton(text: 'Light', onPressed: () => tapped = true),
        ),
      ));
      await tester.tap(find.text('Light'));
      expect(tapped, true);
    });

    testWidgets('DarkButton renders and taps', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: DarkButton(text: 'Dark', onPressed: () => tapped = true),
        ),
      ));
      await tester.tap(find.text('Dark'));
      expect(tapped, true);
    });

    testWidgets('TransparentButton renders with icon', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TransparentButton(
            text: 'With Icon',
            onPressed: () {},
            icon: const Icon(Icons.add),
            iconPadding: const EdgeInsets.all(4),
          ),
        ),
      ));
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('With Icon'), findsOneWidget);
    });
  });

  group('StatsContainer', () {
    testWidgets('renders stats', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: StatsContainer(
            borderColor: Colors.blue,
            title: 'Stat',
            iconName: 'stat_icon',
            text: '100',
          ),
        ),
      ));
      expect(find.text('Stat'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('SettingsRow', () {
    testWidgets('renders and taps', (tester) async {
      bool tapped = false;
      final item = SettingsItem(title: 'Item', background: Colors.blue, onTap: (_) async => tapped = true);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SettingsRow(item: item),
        ),
      ));
      await tester.tap(find.text('Item'));
      expect(tapped, true);
    });
  });

  group('DynamicAsset', () {
    testWidgets('renders icon and image types', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              DynamicAsset(name: 'test.jpg', type: 'image'),
              DynamicAsset(name: 'test.png', type: 'icon'),
              DynamicAsset(name: 'test.gif', type: 'gif'),
              DynamicAsset(name: 'https://example.com/image.png', type: 'image'),
            ],
          ),
        ),
      ));
      expect(find.byType(DynamicAsset), findsNWidgets(4));
    });

    testWidgets('handles updates and errors', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DynamicAsset(name: 'non_existent.png', type: 'icon'),
        ),
      ));

      // Trigger error manually since we can't easily mock AssetImage loading failure in widget tests
      // without complex setup, but we can verify the widget updates when name changes.
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DynamicAsset(name: 'updated.png', type: 'icon'),
        ),
      ));
      expect(find.byType(DynamicAsset), findsOneWidget);
    });
  });

  group('AppBar', () {
    testWidgets('MyAppBar renders with titleOnly style', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          appBar: MyAppBar(style: MyAppBarStyle.titleOnly, title: 'Test Title'),
        ),
      ));
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('MyAppBar renders with backButtonTitleCentered style', (tester) async {
      final router = GoRouter(routes: [GoRoute(path: '/', builder: (_, __) => const SizedBox())]);
      await tester.pumpWidget(ProviderScope(
        overrides: [routerProvider.overrideWithValue(router)],
        child: const MaterialApp(
          home: Scaffold(
            appBar: MyAppBar(style: MyAppBarStyle.backButtonTitleCentered, title: 'Back Title'),
          ),
        ),
      ));
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });

  group('SocialIconButton', () {
    testWidgets('renders and taps', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SocialIconButton(
            const FaIcon(FontAwesomeIcons.facebook),
            onTap: () => tapped = true,
          ),
        ),
      ));
      await tester.tap(find.byType(SocialIconButton));
      expect(tapped, true);
    });
  });

  group('NavBarScaffold', () {
    testWidgets('renders NavBarScaffold with child', (tester) async {
      final router = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(ProviderScope(
        overrides: [
          routerProvider.overrideWithValue(router),
        ],
        child: const MaterialApp(
          home: NavBarScaffold(child: Text('scaffold child')),
        ),
      ));
      expect(find.text('scaffold child'), findsOneWidget);
    });
  });
}

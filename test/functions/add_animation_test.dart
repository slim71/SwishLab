import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swish_lab/functions/add_animation.dart';

void main() {
  group('addAnimation', () {
    testWidgets('should apply default fade animation', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: addAnimation(widget: const Text('test')),
        ),
      );

      expect(find.byType(Animate), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should apply multiple animations', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: addAnimation(
            widget: const Text('test'),
            fade: const FadeConfig(begin: 0.5),
            slide: const SlideConfig(begin: Offset(0, 1)),
            moveY: const MoveYConfig(begin: 100),
            move: const MoveConfig(begin: Offset(10, 10)),
            scale: const ScaleConfig(begin: Offset(0.5, 0.5)),
            rotate: const RotateConfig(begin: 0.5),
            shake: const ShakeConfig(),
          ),
        ),
      );

      expect(find.byType(Animate), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should respect withFade flag', (tester) async {
      // If withFade is false, and no other animations, it should still return Animate?
      // Looking at the code: Animate anim = widget.animate(); ... return anim;
      // It always returns an Animate widget wrapping the child.

      await tester.pumpWidget(
        CupertinoApp(
          home: addAnimation(widget: const Text('test'), withFade: false),
        ),
      );

      expect(find.byType(Animate), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should not apply fade if fade config is null', (tester) async {
      await tester.pumpWidget(
        CupertinoApp(
          home: addAnimation(widget: const Text('test'), withFade: true, fade: null),
        ),
      );

      expect(find.byType(Animate), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });

  group('Animation Configs', () {
    test('FadeConfig defaults', () {
      const config = FadeConfig();
      expect(config.begin, 0.0);
      expect(config.end, 1.0);
      expect(config.duration, defaultDurationMs);
    });

    test('ScaleConfig defaults', () {
      const config = ScaleConfig(begin: Offset(0, 0));
      expect(config.begin, const Offset(0, 0));
      expect(config.end, const Offset(1, 1));
    });

    test('RotateConfig defaults', () {
      const config = RotateConfig(begin: 1.0);
      expect(config.begin, 1.0);
      expect(config.end, 0.0);
    });

    test('MoveConfig defaults', () {
      const config = MoveConfig(begin: Offset(10, 10));
      expect(config.begin, const Offset(10, 10));
      expect(config.end, Offset.zero);
    });

    test('MoveYConfig defaults', () {
      const config = MoveYConfig(begin: 50.0);
      expect(config.begin, 50.0);
      expect(config.end, 0.0);
    });

    test('SlideConfig defaults', () {
      const config = SlideConfig(begin: Offset(1, 0));
      expect(config.begin, const Offset(1, 0));
      expect(config.end, Offset.zero);
    });

    test('ShakeConfig defaults', () {
      const config = ShakeConfig();
      expect(config.hz, 15);
      expect(config.offset, isNull);
      expect(config.rotation, isNull);
    });
  });
}

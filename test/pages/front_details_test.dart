import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/front_details.dart';
import 'package:swish_lab/widgets/icon_action_button.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:go_router/go_router.dart';
import '../test_helper.dart';

class MockImagePickerPlatform extends Mock with MockPlatformInterfaceMixin implements ImagePickerPlatform {}

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('AssetManifest.bin')) {
      return const StandardMessageCodec().encodeMessage(<Object?, Object?>{})!;
    }
    // Return a 1x1 transparent PNG
    return Uint8List.fromList([
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82
    ]).buffer.asByteData();
  }

  @override
  Future<T> loadStructuredData<T>(String key, Future<T> Function(String value) parser) {
    return parser('{}');
  }

  @override
  Future<T> loadStructuredBinaryData<T>(String key, FutureOr<T> Function(ByteData data) parser) async {
    if (key.endsWith('AssetManifest.bin')) {
      final ByteData data = const StandardMessageCodec().encodeMessage(<Object?, Object?>{})!;
      return parser(data);
    }
    return parser(Uint8List(0).buffer.asByteData());
  }

  @override
  Future<ImmutableBuffer> loadBuffer(String key) async {
    final data = Uint8List.fromList([
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
      0x00,
      0x00,
      0x0D,
      0x49,
      0x48,
      0x44,
      0x52,
      0x00,
      0x00,
      0x00,
      0x01,
      0x00,
      0x00,
      0x00,
      0x01,
      0x08,
      0x06,
      0x00,
      0x00,
      0x00,
      0x1F,
      0x15,
      0xC4,
      0x89,
      0x00,
      0x00,
      0x00,
      0x0A,
      0x49,
      0x44,
      0x41,
      0x54,
      0x78,
      0x9C,
      0x63,
      0x00,
      0x01,
      0x00,
      0x00,
      0x05,
      0x00,
      0x01,
      0x0D,
      0x0A,
      0x2D,
      0xB4,
      0x00,
      0x00,
      0x00,
      0x00,
      0x49,
      0x45,
      0x4E,
      0x44,
      0xAE,
      0x42,
      0x60,
      0x82
    ]);
    return ImmutableBuffer.fromUint8List(data);
  }
}

void main() {
  late MockImagePickerPlatform mockImagePicker;

  setUp(() {
    mockImagePicker = MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockImagePicker;
  });

  group('FrontDetails', () {
    testWidgets('renders and navigates back', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final router = GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => const FrontDetails()),
        GoRoute(path: '/home', name: 'home', builder: (_, __) => const Text('Home')),
      ]);

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: router,
          child: const FrontDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Front view analysis'), findsOneWidget);

      // We need a page on top to pop it
      router.push('/');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Back on root or popped
    });

    testWidgets('picks video and navigates to pre-upload', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      final router = GoRouter(routes: [
        GoRoute(path: '/', builder: (_, __) => const FrontDetails()),
        GoRoute(
            path: '/pre-upload/:perspective', name: 'pre-upload', builder: (_, __) => const Text('Pre-Upload Page')),
      ]);

      when(() => mockImagePicker.getVideo(
            source: ImageSource.gallery,
            maxDuration: any(named: 'maxDuration'),
          )).thenAnswer((_) async => XFile('test.mp4'));

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: router,
          child: const FrontDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconActionButton).last);
      await tester.pumpAndSettle();

      expect(find.text('Pre-Upload Page'), findsOneWidget);
    });

    testWidgets('handles image picker cancellation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockImagePicker.getVideo(
            source: ImageSource.gallery,
            maxDuration: any(named: 'maxDuration'),
          )).thenAnswer((_) async => null);

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          child: const FrontDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconActionButton).last);
      await tester.pumpAndSettle();

      expect(find.text('Front view analysis'), findsOneWidget);
    });

    testWidgets('handles image picker exception', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      when(() => mockImagePicker.getVideo(
            source: ImageSource.gallery,
            maxDuration: any(named: 'maxDuration'),
          )).thenThrow(Exception('Picker error'));

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          child: const FrontDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconActionButton).last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Failed to upload data'), findsOneWidget);
    });

    testWidgets('tap background unfocuses', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          child: const FrontDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      final focusNode = FocusNode();
      FocusManager.instance.rootScope.requestFocus(focusNode);
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      // Tap background GIF area
      await tester.tapAt(const Offset(400, 300));
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
    });
  });
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/side_details.dart';
import 'package:swish_lab/widgets/icon_action_button.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
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

  group('SideDetails', () {
    testWidgets('renders and navigates back', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: mockRouter,
          child: const SideDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Side view analysis'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      verify(() => mockRouter.pop()).called(1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('picks video and navigates to pre-upload', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();
      when(() => mockRouter.pushNamed(any(), extra: any(named: 'extra'))).thenAnswer((_) async => null);

      when(() => mockImagePicker.getVideo(
            source: ImageSource.gallery,
            maxDuration: any(named: 'maxDuration'),
          )).thenAnswer((_) async => XFile('test.mp4'));

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: mockRouter,
          child: const SideDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      // Find upload button (the one with the cloud upload icon)
      // It's an IconActionButton
      await tester.tap(find.byType(IconActionButton).last);
      await tester.pumpAndSettle();

      verify(() => mockRouter.pushNamed(
            'pre-upload',
            pathParameters: any(named: 'pathParameters'),
            queryParameters: any(named: 'queryParameters'),
            extra: any(named: 'extra'),
          )).called(1);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles image picker cancellation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      when(() => mockImagePicker.getVideo(
            source: ImageSource.gallery,
            maxDuration: any(named: 'maxDuration'),
          )).thenAnswer((_) async => null);

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: mockRouter,
          child: const SideDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(IconActionButton).last);
      await tester.pumpAndSettle();

      verifyNever(() => mockRouter.pushNamed('pre-upload', extra: any(named: 'extra')));

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tap to unfocus', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          child: const SideDetails(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Side view analysis'));
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}

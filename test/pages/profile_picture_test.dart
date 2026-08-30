import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swish_lab/pages/profile_picture.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/models/users_row.dart';
import 'package:swish_lab/state/app_state.dart';
import 'package:swish_lab/models/user_row_data.dart';
import 'package:swish_lab/features/upload_profile_picture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import '../test_helper.dart';

class MockChangeProfilePicture extends Mock implements ChangeProfilePicture {
  @override
  Future<String> execute({required String userId, File? localFile, String? networkUrl});
}

class MockImagePickerPlatform extends Mock with MockPlatformInterfaceMixin implements ImagePickerPlatform {}

class FakeImagePickerOptions extends Fake implements ImagePickerOptions {}

class MockAssetBundle extends Fake implements AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('AssetManifest.bin')) {
      return const StandardMessageCodec().encodeMessage(<Object?, Object?>{})!;
    }
    // Return a 1x1 transparent PNG to avoid "Invalid image data"
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

class MockAppStateNotifier extends AppStateNotifier {
  final AppState initialState;
  MockAppStateNotifier(this.initialState);

  @override
  AppState build() => initialState;
}

void main() {
  late MockChangeProfilePicture mockUseCase;
  late UsersRow testUser;
  late MockImagePickerPlatform mockImagePicker;

  setUpAll(() {
    testUser = UsersRow(
      id: '123',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
      createdAt: DateTime.now(),
    );
    registerFallbackValue(File(''));
    registerFallbackValue(FakeImagePickerOptions());
    registerFallbackValue(ImageSource.gallery);
  });

  setUp(() {
    mockUseCase = MockChangeProfilePicture();
    mockImagePicker = MockImagePickerPlatform();
    ImagePickerPlatform.instance = mockImagePicker;
  });

  group('ProfilePicturePage', () {
    testWidgets('renders initial state and handles URL flow', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          overrides: [
            appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(userData: UserRowData()))),
          ],
          child: const ProfilePicturePage(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('URL'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'https://example.com/img.png');
      await tester.tap(find.text('Load URL'));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('pickLocalImage and save', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      final mockRouter = MockGoRouter();

      when(() => mockImagePicker.getImageFromSource(
            source: any(named: 'source'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => XFile('test.png'));

      when(() => mockUseCase.execute(
            userId: any(named: 'userId'),
            localFile: any(named: 'localFile'),
            networkUrl: any(named: 'networkUrl'),
          )).thenAnswer((_) async => 'https://uploaded.com/img.png');

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          router: mockRouter,
          overrides: [
            appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
            changeProfilePictureProvider.overrideWithValue(mockUseCase),
            appStateProvider
                .overrideWith(() => MockAppStateNotifier(const AppState(userData: UserRowData(userID: '123')))),
          ],
          child: const ProfilePicturePage(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();

      // Tap Gallery ListTile in sheet
      await tester.tap(find.text('Gallery').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      verify(() => mockRouter.goNamed('home')).called(1);

      // Test error path
      when(() => mockUseCase.execute(
            userId: any(named: 'userId'),
            localFile: any(named: 'localFile'),
            networkUrl: any(named: 'networkUrl'),
          )).thenThrow(Exception('Upload failed'));

      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Error uploading profile picture'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('pickLocalImage cancelled or invalid format', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1200));

      // User cancels source selection
      when(() => mockImagePicker.getImageFromSource(
            source: any(named: 'source'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => null);

      await tester.pumpWidget(DefaultAssetBundle(
        bundle: MockAssetBundle(),
        child: createTestWidget(
          overrides: [
            appUserProvider.overrideWithValue(AsyncValue.data(testUser)),
            appStateProvider.overrideWith(() => MockAppStateNotifier(const AppState(userData: UserRowData()))),
          ],
          child: const ProfilePicturePage(),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Camera')); // Pick camera
      await tester.pumpAndSettle();

      // Invalid format test
      when(() => mockImagePicker.getImageFromSource(
            source: any(named: 'source'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => XFile('test.txt')); // Not jpg/png

      await tester.tap(find.text('Gallery'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gallery').last);
      await tester.pumpAndSettle();
      expect(find.text('Invalid image format. Please select another one'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    });
  });
}

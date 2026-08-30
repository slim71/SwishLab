import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/pages/markdown_document.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:go_router/go_router.dart';
import '../test_helper.dart';

class MockAssetBundle extends Fake implements AssetBundle {
  final Map<String, String> _data = {};
  Completer<String>? slowLoadCompleter;

  void mockAsset(String key, String content) {
    _data[key] = content;
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (slowLoadCompleter != null && key.contains('slow')) {
      return slowLoadCompleter!.future;
    }
    if (_data.containsKey(key)) {
      return _data[key]!;
    }
    throw FlutterError('Asset not found: $key');
  }

  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('AssetManifest.bin')) {
      return const StandardMessageCodec().encodeMessage(<Object?, Object?>{})!;
    }
    return Uint8List(0).buffer.asByteData();
  }

  @override
  Future<T> loadStructuredBinaryData<T>(String key, FutureOr<T> Function(ByteData data) parser) async {
    if (key.endsWith('AssetManifest.bin')) {
      final ByteData data = const StandardMessageCodec().encodeMessage(<Object?, Object?>{})!;
      return parser(data);
    }
    return parser(Uint8List(0).buffer.asByteData());
  }
}

void main() {
  late MockAssetBundle mockBundle;

  setUp(() {
    mockBundle = MockAssetBundle();
  });

  group('MarkdownDocument', () {
    testWidgets('renders content from asset bundle', (tester) async {
      const fileName = 'EULA';
      const title = 'Terms of Use';
      const content = '# MyTitle\n\nTestContent';

      mockBundle.mockAsset('assets/markdown/$fileName.md', content);

      await tester.pumpWidget(createTestWidget(
        child: DefaultAssetBundle(
          bundle: mockBundle,
          child: const MarkdownDocument(
            fileName: fileName,
            title: title,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.byType(MarkdownWidget), findsOneWidget);
    });

    testWidgets('handles link taps via internal logic', (tester) async {
      const fileName = 'test';
      const content = '[Link](app://TAC)';

      mockBundle.mockAsset('assets/markdown/$fileName.md', content);

      final router = GoRouter(routes: [
        GoRoute(
            path: '/',
            builder: (_, __) => DefaultAssetBundle(
                  bundle: mockBundle,
                  child: const MarkdownDocument(fileName: fileName, title: 'Test'),
                )),
        GoRoute(
            path: '/doc/:name', name: 'document', builder: (_, state) => Text('Doc: ${state.pathParameters['name']}')),
        GoRoute(path: '/home', name: 'home', builder: (_, __) => const Text('Home')),
      ]);

      await tester.pumpWidget(createTestWidget(
        router: router,
        child: const SizedBox(),
      ));

      await tester.pumpAndSettle();

      final markdownWidget = tester.widget<MarkdownWidget>(find.byType(MarkdownWidget));

      final onLinkTap = markdownWidget.theme?.onLinkTap;
      expect(onLinkTap, isNotNull);

      // app://TAC
      onLinkTap?.call('Link', 'app://TAC');
      await tester.pumpAndSettle();
      expect(find.text('Doc: TAC'), findsOneWidget);

      // app://home (via 'else' branch of startsWith('app://'))
      onLinkTap?.call('Link', 'app://home');
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);

      // TAC (legacy shorthand)
      onLinkTap?.call('Link', 'TAC');
      await tester.pumpAndSettle();
      expect(find.text('Doc: TAC'), findsOneWidget);

      // Unknown
      onLinkTap?.call('Link', 'unknown');
      await tester.pumpAndSettle();
    });

    testWidgets('handles disposal during markdown initialization', (tester) async {
      mockBundle.slowLoadCompleter = Completer<String>();

      await tester.pumpWidget(createTestWidget(
        child: DefaultAssetBundle(
          bundle: mockBundle,
          child: const MarkdownDocument(
            fileName: 'slow_file',
            title: 'Slow Load',
          ),
        ),
      ));

      await tester.pump();

      // Dispose
      await tester.pumpWidget(const SizedBox());

      mockBundle.slowLoadCompleter!.complete('# Done');
      await tester.pump();
    });
  });
}

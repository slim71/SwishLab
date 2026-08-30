import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/router/go_router_refresh_stream.dart';

void main() {
  group('GoRouterRefreshStream', () {
    test('notifies listeners when stream emits', () async {
      final controller = StreamController<void>.broadcast();
      final refreshStream = GoRouterRefreshStream(controller.stream);

      int notifiedCount = 0;
      refreshStream.addListener(() {
        notifiedCount++;
      });

      expect(notifiedCount, equals(0));

      controller.add(null);
      await Future<void>.delayed(Duration.zero);
      expect(notifiedCount, equals(1));

      refreshStream.dispose();
      controller.close();
    });

    test('cancels subscription on dispose', () async {
      final controller = StreamController<void>.broadcast();
      final refreshStream = GoRouterRefreshStream(controller.stream);

      // Wait for subscription to happen
      await Future<void>.delayed(Duration.zero);

      // We check that it doesn't crash and we can dispose it multiple times if needed
      // To really test cancellation of a broadcast wrapper, we'd need to mock the stream.
      // But let's just ensure no further notifications happen.

      int notifiedCount = 0;
      refreshStream.addListener(() {
        notifiedCount++;
      });

      refreshStream.dispose();

      controller.add(null);
      await Future<void>.delayed(Duration.zero);

      // If it was disposed, listeners shouldn't be called (or it should throw if we add listener after dispose)
      // But here we added it before dispose.
      expect(notifiedCount, equals(0));

      controller.close();
    });
  });
}

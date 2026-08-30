import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/providers/shooting_analysis_provider.dart';
import 'package:swish_lab/controllers/shooting_analysis_notifier.dart';

void main() {
  group('ShootingAnalysisProvider', () {
    test('shootingAnalysisProvider initializes ShootingAnalysisController', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(shootingAnalysisProvider.notifier);
      expect(controller, isA<ShootingAnalysisController>());
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:swish_lab/models/custom_enums.dart';

void main() {
  group('Custom Enums Tests', () {
    test('OriginFunc enum values', () {
      expect(OriginFunc.values.length, 2);
      expect(OriginFunc.side.name, 'side');
      expect(OriginFunc.front.name, 'front');

      // Touching all values for coverage
      for (var value in OriginFunc.values) {
        expect(value, isA<OriginFunc>());
      }
    });

    test('AssetType enum values', () {
      expect(AssetType.values.length, 3);
      expect(AssetType.icon.name, 'icon');
      expect(AssetType.image.name, 'image');
      expect(AssetType.gif.name, 'gif');

      for (var value in AssetType.values) {
        expect(value, isA<AssetType>());
      }
    });

    test('ChipsDirection enum values', () {
      expect(ChipsDirection.values.length, 3);
      expect(ChipsDirection.wrap.name, 'wrap');
      expect(ChipsDirection.horizontal.name, 'horizontal');
      expect(ChipsDirection.vertical.name, 'vertical');

      for (var value in ChipsDirection.values) {
        expect(value, isA<ChipsDirection>());
      }
    });

    test('Handedness enum values', () {
      expect(Handedness.values.length, 2);
      expect(Handedness.left.name, 'left');
      expect(Handedness.right.name, 'right');

      for (var value in Handedness.values) {
        expect(value, isA<Handedness>());
      }
    });
  });
}

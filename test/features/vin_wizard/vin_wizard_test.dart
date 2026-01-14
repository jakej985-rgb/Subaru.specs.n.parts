import 'package:flutter_test/flutter_test.dart';
import 'package:specsnparts/features/vin_wizard/vin_decoder.dart';

void main() {
  group('VinDecoder', () {
    test('identifies 2004 Impreza correctly', () {
      // 10th digit '4' is 2004
      // 4th/5th 'GD' is Impreza Sedan
      const vin = 'JF1GD296X4GXXXXXX';
      final result = VinDecoder.decode(vin);

      expect(result.isValid, true);
      expect(result.year, 2004);
      expect(result.model, 'Impreza');
    });

    test('identifies 2011 Legacy correctly', () {
      // 10th digit 'B' is 2011
      // 4th/5th 'BM' is Legacy Sedan
      const vin = '4S3BMXXXXBXXXXXXX';
      final result = VinDecoder.decode(vin);

      expect(result.isValid, true);
      expect(result.year, 2011);
      expect(result.model, 'Legacy');
    });

    test('returns invalid for non-subaru or short vin', () {
      expect(VinDecoder.decode('123').isValid, false);
      expect(VinDecoder.decode('AAAAAAAAAAAAAAAAA').isValid, false);
    });
  });
}

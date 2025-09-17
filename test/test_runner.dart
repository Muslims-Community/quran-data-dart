import 'package:test/test.dart';

// Import all test files
import 'models/ayah_test.dart' as ayah_test;
import 'services/quran_service_test.dart' as quran_service_test;
import 'utils/extensions_test.dart' as extensions_test;

void main() {
  group('All Tests', () {
    group('Model Tests', () {
      ayah_test.main();
    });

    group('Service Tests', () {
      quran_service_test.main();
    });

    group('Extension Tests', () {
      extensions_test.main();
    });
  });
}
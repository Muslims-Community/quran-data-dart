import 'package:test/test.dart';
import 'package:quran_data_dart/models/ayah.dart';
import 'package:quran_data_dart/models/surah.dart';

void main() {
  group('Ayah', () {
    test('should create Ayah instance with all required properties', () {
      final ayah = Ayah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      expect(ayah.id, equals(1));
      expect(ayah.text, equals('بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ'));
      expect(ayah.juz, equals(1));
      expect(ayah.hizb, equals(1));
      expect(ayah.sajdah, isFalse);
    });

    test('should create Ayah with sajdah property', () {
      final ayah = Ayah(
        id: 206,
        text: 'إِنَّ الَّذِينَ عِندَ رَبِّكَ لَا يَسْتَكْبِرُونَ عَنْ عِبَادَتِهِۦ وَيُسَبِّحُونَهُۥ وَلَهُۥ يَسْجُدُونَ',
        sajdah: true,
        juz: 9,
        hizb: 17,
      );

      expect(ayah.sajdah, isTrue);
    });

    test('should serialize to JSON correctly', () {
      final ayah = Ayah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      final json = ayah.toJson();

      expect(json['id'], equals(1));
      expect(json['text'], equals('بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ'));
      expect(json['juz'], equals(1));
      expect(json['hizb'], equals(1));
      expect(json['sajdah'], equals(false));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'id': 255,
        'text': 'اللَّهُ لَا إِلَـٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        'juz': 3,
        'hizb': 5,
        'sajdah': false,
      };

      final ayah = Ayah.fromJson(json);

      expect(ayah.id, equals(255));
      expect(ayah.text, equals('اللَّهُ لَا إِلَـٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ'));
      expect(ayah.juz, equals(3));
      expect(ayah.hizb, equals(5));
      expect(ayah.sajdah, isFalse);
    });

    test('should handle equality correctly', () {
      final ayah1 = Ayah(
        id: 1,
        text: 'Test text',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      final ayah2 = Ayah(
        id: 1,
        text: 'Test text',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      final ayah3 = Ayah(
        id: 2,
        text: 'Different text',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      expect(ayah1, equals(ayah2));
      expect(ayah1, isNot(equals(ayah3)));
      expect(ayah1.hashCode, equals(ayah2.hashCode));
    });

    test('should have proper string representation', () {
      final ayah = Ayah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      final str = ayah.toString();
      expect(str, contains('Ayah'));
      expect(str, contains('id: 1'));
      expect(str, contains('sajdah: false'));
    });

    test('should copy with new values', () {
      final ayah = Ayah(
        id: 1,
        text: 'Original text',
        sajdah: false,
        juz: 1,
        hizb: 1,
      );

      final copied = ayah.copyWith(
        id: 2,
        text: 'New text',
        sajdah: true,
      );

      expect(copied.id, equals(2));
      expect(copied.text, equals('New text'));
      expect(copied.sajdah, isTrue);
      expect(copied.juz, equals(1)); // unchanged
      expect(copied.hizb, equals(1)); // unchanged
    });
  });

  group('AyahWithSurah', () {
    late Surah testSurah;

    setUp(() {
      testSurah = Surah(
        id: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatiha',
        revelationType: 'Meccan',
        numberOfAyahs: 7,
        revelationOrder: 5,
        ayat: [],
      );
    });

    test('should create AyahWithSurah instance with all properties', () {
      final ayah = AyahWithSurah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
        surah: testSurah,
      );

      expect(ayah.id, equals(1));
      expect(ayah.text, equals('بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ'));
      expect(ayah.surah.id, equals(1));
      expect(ayah.surah.englishName, equals('Al-Fatiha'));
      expect(ayah.juz, equals(1));
      expect(ayah.hizb, equals(1));
      expect(ayah.sajdah, isFalse);
      expect(ayah.source, contains('Tanzil'));
    });

    test('should serialize AyahWithSurah to JSON correctly', () {
      final ayah = AyahWithSurah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
        surah: testSurah,
      );

      final json = ayah.toJson();

      expect(json['id'], equals(1));
      expect(json['text'], equals('بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ'));
      expect(json['surah'], isA<Map<String, dynamic>>());
      expect(json['source'], contains('Tanzil'));
    });

    test('should have proper string representation with surah info', () {
      final ayah = AyahWithSurah(
        id: 1,
        text: 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ',
        sajdah: false,
        juz: 1,
        hizb: 1,
        surah: testSurah,
      );

      final str = ayah.toString();
      expect(str, contains('AyahWithSurah'));
      expect(str, contains('Al-Fatiha'));
      expect(str, contains('id: 1'));
    });
  });
}
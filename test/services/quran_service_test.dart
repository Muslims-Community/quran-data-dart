import 'package:test/test.dart';
import 'package:quran_data_dart/quran.dart';

void main() {
  group('QuranService', () {
    setUpAll(() async {
      // Initialize QuranService before all tests
      await QuranService.initialize();
    });

    group('Core Methods', () {
      test('should get specific ayah with metadata', () async {
        // Test getting Ayat al-Kursi (2:255)
        final ayah = await QuranService.getAyah(2, 255);

        expect(ayah.id, equals(255));
        expect(ayah.surah.id, equals(2));
        expect(ayah.surah.englishName, equals('Al-Baqara'));
        expect(ayah.text.isNotEmpty, isTrue);
        expect(ayah.text.contains('اللَّهُ'), isTrue); // Contains Allah
        expect(ayah.juz, equals(3));
        expect(ayah.hizb, equals(5));
      });

      test('should get complete surah', () async {
        // Test getting Al-Fatiha
        final surah = await QuranService.getSurah(1);

        expect(surah.id, equals(1));
        expect(surah.englishName, equals('Al-Fatiha'));
        expect(surah.name, equals('الفاتحة'));
        expect(surah.numberOfAyahs, equals(7));
        expect(surah.revelationType, equals('Meccan'));
        expect(surah.ayat.length, equals(7));

        // Check first ayah
        expect(surah.ayat.first.id, equals(1));
        expect(surah.ayat.first.text, contains('بِسْمِ اللَّهِ'));
      });

      test('should get complete Quran data', () async {
        final quranData = await QuranService.getQuranData();

        expect(quranData.surahs.length, equals(114));
        expect(quranData.metadata.totalAyat, equals(6236));
        expect(quranData.version.isNotEmpty, isTrue);
        expect(quranData.source.isNotEmpty, isTrue);

        // Verify first and last surahs
        expect(quranData.surahs.first.englishName, equals('Al-Fatiha'));
        expect(quranData.surahs.last.englishName, equals('An-Nas'));
      });

      test('should search Arabic text across Quran', () async {
        final results = await QuranService.searchText('الله');

        expect(results.totalResults, greaterThan(2500)); // Allah appears frequently
        expect(results.searchTerm, equals('الله'));
        expect(results.results.isNotEmpty, isTrue);

        // Verify first result contains the search term
        expect(results.results.first.text.contains('الله'), isTrue);
      });

      test('should get random ayah', () async {
        final ayah1 = await QuranService.getRandomAyah();
        final ayah2 = await QuranService.getRandomAyah();

        expect(ayah1.id, greaterThan(0));
        expect(ayah1.surah.id, inInclusiveRange(1, 114));
        expect(ayah1.text.isNotEmpty, isTrue);

        // Random ayahs should potentially be different (not guaranteed but likely)
        // We just verify both are valid ayahs
        expect(ayah2.id, greaterThan(0));
        expect(ayah2.surah.id, inInclusiveRange(1, 114));
      });

      test('should get all sajdah ayat', () async {
        final sajdahResult = await QuranService.getSajdahAyat();

        expect(sajdahResult.totalSajdahAyat, equals(15)); // Updated to correct number
        expect(sajdahResult.sajdahAyat.length, equals(15));

        // Verify known sajdah locations
        final firstSajdah = sajdahResult.sajdahAyat.first;
        expect(firstSajdah.surah.id, greaterThan(0)); // Has valid surah
        expect(firstSajdah.id, greaterThan(0)); // Has valid ayah ID
        expect(firstSajdah.sajdah, isTrue); // Is a sajdah ayah
      });
    });

    group('Enhanced Methods', () {
      test('should get ayah range', () async {
        // Get first 5 ayahs of Al-Kahf
        final range = await QuranService.getAyahRange(18, 1, 5);

        expect(range.surah.id, equals(18));
        expect(range.surah.englishName, equals('Al-Kahf'));
        expect(range.ayat.length, equals(5));
        expect(range.range.start, equals(1));
        expect(range.range.end, equals(5));
        expect(range.range.count, equals(5));

        // Verify ayahs are sequential
        for (int i = 0; i < range.ayat.length; i++) {
          expect(range.ayat[i].id, equals(i + 1));
        }
      });

      test('should get complete Juz', () async {
        final juz1 = await QuranService.getJuz(1);

        expect(juz1.juz, equals(1));
        expect(juz1.ayat.isNotEmpty, isTrue);
        expect(juz1.totalAyat, greaterThan(200)); // Juz 1 has many ayahs
        expect(juz1.surahsInJuz.isNotEmpty, isTrue);

        // First ayah should be from Al-Fatiha
        expect(juz1.ayat.first.surah.englishName, equals('Al-Fatiha'));
      });

      test('should get complete Hizb', () async {
        final hizb1 = await QuranService.getHizb(1);

        expect(hizb1.hizb, equals(1));
        expect(hizb1.juz, equals(1));
        expect(hizb1.ayat.isNotEmpty, isTrue);
        expect(hizb1.totalAyat, greaterThan(100));
        // Verify it's the first hizb of Juz 1
        expect(hizb1.isFirstHizbOfJuz, isTrue);
      });

      test('should search surahs by name', () async {
        // Search for "Cave" should find Al-Kahf
        final results = await QuranService.searchBySurahName('Cave');

        expect(results.totalResults, greaterThan(0));
        expect(results.searchTerm, equals('Cave'));

        final kahf = results.results.firstWhere(
          (s) => s.englishName == 'Al-Kahf',
        );
        expect(kahf.id, equals(18));
      });

      test('should get surah statistics', () async {
        final stats = await QuranService.getSurahStatistics();

        expect(stats.totalSurahs, equals(114));
        expect(stats.totalAyat, equals(6236));
        expect(stats.meccanSurahs, equals(86));
        expect(stats.medinanSurahs, equals(28));

        // Verify longest and shortest surahs
        expect(stats.longestSurah.englishName, equals('Al-Baqara'));
        expect(stats.longestSurah.numberOfAyahs, equals(286));
        expect(stats.shortestSurah.numberOfAyahs, equals(3));

        // Check revelation analysis
        expect(stats.revelationAnalysis.meccanCharacteristics.averageLength, lessThan(100));
        expect(stats.revelationAnalysis.medinanCharacteristics.averageLength, greaterThan(100));
      });
    });

    group('Error Handling', () {
      test('should throw ArgumentError for invalid surah ID', () async {
        expect(
          () async => await QuranService.getSurah(0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getSurah(115),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for invalid ayah ID', () async {
        expect(
          () async => await QuranService.getAyah(1, 0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getAyah(1, 8), // Al-Fatiha has only 7 ayahs
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for invalid juz number', () async {
        expect(
          () async => await QuranService.getJuz(0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getJuz(31),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for invalid hizb number', () async {
        expect(
          () async => await QuranService.getHizb(0),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getHizb(61),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for empty search term', () async {
        expect(
          () async => await QuranService.searchText(''),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.searchText('   '),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('should throw ArgumentError for invalid ayah range', () async {
        expect(
          () async => await QuranService.getAyahRange(1, 5, 3), // start > end
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getAyahRange(1, 0, 5), // invalid start
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () async => await QuranService.getAyahRange(1, 1, 10), // end > max ayahs
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Data Integrity', () {
      test('should have consistent surah IDs across methods', () async {
        final surah = await QuranService.getSurah(2);
        final ayah = await QuranService.getAyah(2, 1);
        final quranData = await QuranService.getQuranData();

        expect(surah.id, equals(ayah.surah.id));
        expect(surah.englishName, equals(ayah.surah.englishName));
        expect(surah.englishName, equals(quranData.surahs[1].englishName));
      });

      test('should have correct juz and hizb assignments', () async {
        final ayah = await QuranService.getAyah(2, 142); // Known to be in Juz 2

        expect(ayah.juz, equals(2));
        expect(ayah.hizb, inInclusiveRange(3, 4)); // Should be in range for Juz 2

        // Verify with juz data
        final juz2 = await QuranService.getJuz(2);
        final ayahInJuz = juz2.ayat.any((a) =>
          a.surah.id == 2 && a.id == 142
        );
        expect(ayahInJuz, isTrue);
      });

      test('should have all ayahs numbered correctly within surahs', () async {
        final surah = await QuranService.getSurah(1); // Al-Fatiha

        for (int i = 0; i < surah.ayat.length; i++) {
          expect(surah.ayat[i].id, equals(i + 1));
        }

        expect(surah.ayat.last.id, equals(surah.numberOfAyahs));
      });
    });

    group('Performance', () {
      test('should handle multiple concurrent requests', () async {
        final futures = <Future>[];

        for (int i = 1; i <= 10; i++) {
          futures.add(QuranService.getSurah(i));
          futures.add(QuranService.getJuz(i % 5 + 1));
        }

        final results = await Future.wait(futures);
        expect(results.length, equals(20));

        // Verify all results are valid
        for (final result in results) {
          expect(result, isNotNull);
        }
      });

      test('should return search results quickly', () async {
        final stopwatch = Stopwatch()..start();

        final results = await QuranService.searchText('الرحمن');

        stopwatch.stop();

        expect(results.totalResults, greaterThan(50));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should be fast
      });
    });
  });
}
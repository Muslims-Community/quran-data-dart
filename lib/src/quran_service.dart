import 'dart:math';
import '../models/ayah.dart';
import '../models/surah.dart';
import '../models/search_result.dart';
import '../models/surah_search_result.dart';
import '../models/juz_result.dart';
import '../models/hizb_result.dart';
import '../models/ayah_range.dart';
import '../models/surah_statistics.dart';
import '../models/sajdah_result.dart';
import '../models/quran_data.dart';
import 'quran_data_loader.dart';
import 'utils/validators.dart';

/// The main service class providing access to Quran data and functionality.
///
/// This class serves as the primary interface for accessing Quran content,
/// search functionality, and Islamic reading divisions.
class QuranService {
  static QuranService? _instance;
  static QuranData? _quranData;
  static final Random _random = Random();

  /// Private constructor for singleton pattern
  QuranService._();

  /// Get the singleton instance of QuranService
  static QuranService get instance {
    _instance ??= QuranService._();
    return _instance!;
  }

  /// Initialize the service by loading Quran data
  static Future<void> initialize() async {
    _quranData ??= await QuranDataLoader.loadQuranData();
  }

  /// Ensure data is loaded before operations
  static void _ensureDataLoaded() {
    if (_quranData == null) {
      throw StateError(
          'QuranService not initialized. Call QuranService.initialize() first.');
    }
  }

  /// Get a specific ayah from the Quran.
  ///
  /// [surahId] The surah number (1-114)
  /// [ayahId] The ayah number within the surah (1-n)
  ///
  /// Returns [AyahWithSurah] containing the ayah and its surah information.
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  ///
  /// Example:
  /// ```dart
  /// final ayah = await QuranService.getAyah(2, 255); // Ayat al-Kursi
  /// print(ayah.text);
  /// ```
  static Future<AyahWithSurah> getAyah(int surahId, int ayahId) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateSurahId(surahId);

    final surah = _quranData!.surahs.firstWhere(
      (s) => s.id == surahId,
      orElse: () => throw ArgumentError('Surah $surahId not found'),
    );

    QuranValidators.validateAyahId(ayahId, surah.numberOfAyahs);

    final ayah = surah.ayat.firstWhere(
      (a) => a.id == ayahId,
      orElse: () =>
          throw ArgumentError('Ayah $ayahId not found in surah $surahId'),
    );

    return AyahWithSurah(
      id: ayah.id,
      text: ayah.text,
      sajdah: ayah.sajdah,
      juz: ayah.juz,
      hizb: ayah.hizb,
      surah: surah,
    );
  }

  /// Get a complete surah with all its ayat.
  ///
  /// [surahId] The surah number (1-114)
  ///
  /// Returns [Surah] containing all ayat of the specified surah.
  ///
  /// Throws [ArgumentError] if surahId is invalid.
  ///
  /// Example:
  /// ```dart
  /// final surah = await QuranService.getSurah(1); // Al-Fatiha
  /// print('${surah.englishName}: ${surah.numberOfAyahs} ayat');
  /// ```
  static Future<Surah> getSurah(int surahId) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateSurahId(surahId);

    return _quranData!.surahs.firstWhere(
      (s) => s.id == surahId,
      orElse: () => throw ArgumentError('Surah $surahId not found'),
    );
  }

  /// Get the complete Quran dataset.
  ///
  /// Returns [QuranData] containing all surahs and metadata.
  ///
  /// Example:
  /// ```dart
  /// final quranData = await QuranService.getQuranData();
  /// print('Total ayat: ${quranData.metadata.totalAyat}');
  /// ```
  static Future<QuranData> getQuranData() async {
    await initialize();
    _ensureDataLoaded();

    return _quranData!;
  }

  /// Search for Arabic text within the Quran.
  ///
  /// [searchTerm] The Arabic text to search for
  ///
  /// Returns [SearchResult] containing all matching ayat.
  ///
  /// Throws [ArgumentError] if searchTerm is empty.
  ///
  /// Example:
  /// ```dart
  /// final results = await QuranService.searchText('الله');
  /// print('Found ${results.totalResults} ayat containing "الله"');
  /// ```
  static Future<SearchResult> searchText(String searchTerm) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateSearchTerm(searchTerm);

    final List<AyahWithSurah> results = [];

    for (final surah in _quranData!.surahs) {
      for (final ayah in surah.ayat) {
        if (ayah.text.contains(searchTerm)) {
          results.add(AyahWithSurah(
            id: ayah.id,
            text: ayah.text,
            sajdah: ayah.sajdah,
            juz: ayah.juz,
            hizb: ayah.hizb,
            surah: surah,
          ));
        }
      }
    }

    return SearchResult(
      searchTerm: searchTerm,
      totalResults: results.length,
      results: results,
    );
  }

  /// Get a random ayah from the Quran.
  ///
  /// Returns [AyahWithSurah] containing a randomly selected ayah.
  ///
  /// Example:
  /// ```dart
  /// final randomAyah = await QuranService.getRandomAyah();
  /// print('Random ayah from ${randomAyah.surah.englishName}');
  /// ```
  static Future<AyahWithSurah> getRandomAyah() async {
    await initialize();
    _ensureDataLoaded();

    final randomSurahIndex = _random.nextInt(_quranData!.surahs.length);
    final randomSurah = _quranData!.surahs[randomSurahIndex];

    final randomAyahIndex = _random.nextInt(randomSurah.ayat.length);
    final randomAyah = randomSurah.ayat[randomAyahIndex];

    return AyahWithSurah(
      id: randomAyah.id,
      text: randomAyah.text,
      sajdah: randomAyah.sajdah,
      juz: randomAyah.juz,
      hizb: randomAyah.hizb,
      surah: randomSurah,
    );
  }

  /// Get all ayat where sajdah (prostration) is recommended.
  ///
  /// Returns [SajdahResult] containing all 15 sajdah ayat.
  ///
  /// Example:
  /// ```dart
  /// final sajdahAyat = await QuranService.getSajdahAyat();
  /// print('Total sajdah ayat: ${sajdahAyat.totalSajdahAyat}');
  /// ```
  static Future<SajdahResult> getSajdahAyat() async {
    await initialize();
    _ensureDataLoaded();

    final List<AyahWithSurah> sajdahAyat = [];

    for (final surah in _quranData!.surahs) {
      for (final ayah in surah.ayat) {
        if (ayah.sajdah) {
          sajdahAyat.add(AyahWithSurah(
            id: ayah.id,
            text: ayah.text,
            sajdah: ayah.sajdah,
            juz: ayah.juz,
            hizb: ayah.hizb,
            surah: surah,
          ));
        }
      }
    }

    return SajdahResult(
      totalSajdahAyat: sajdahAyat.length,
      sajdahAyat: sajdahAyat,
    );
  }

  /// Get a range of consecutive ayat from a specific surah.
  ///
  /// [surahId] The surah number (1-114)
  /// [startAyah] Starting ayah number (inclusive)
  /// [endAyah] Ending ayah number (inclusive)
  ///
  /// Returns [AyahRange] containing the specified range of ayat.
  ///
  /// Throws [ArgumentError] if parameters are invalid.
  ///
  /// Example:
  /// ```dart
  /// final range = await QuranService.getAyahRange(2, 1, 5); // Al-Baqarah 1-5
  /// print('Reading ${range.range.count} ayat from ${range.surah.englishName}');
  /// ```
  static Future<AyahRange> getAyahRange(
      int surahId, int startAyah, int endAyah) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateSurahId(surahId);

    final surah = _quranData!.surahs.firstWhere(
      (s) => s.id == surahId,
      orElse: () => throw ArgumentError('Surah $surahId not found'),
    );

    QuranValidators.validateAyahRange(startAyah, endAyah, surah.numberOfAyahs);

    final ayatInRange = surah.ayat
        .where((ayah) => ayah.id >= startAyah && ayah.id <= endAyah)
        .toList();

    return AyahRange(
      surah: surah,
      range: AyahRangeInfo(
        start: startAyah,
        end: endAyah,
        count: ayatInRange.length,
      ),
      ayat: ayatInRange,
    );
  }

  /// Get all ayat from a specific Juz (Para).
  ///
  /// [juzNumber] The Juz number (1-30)
  ///
  /// Returns [JuzResult] containing all ayat in the specified Juz.
  ///
  /// Throws [ArgumentError] if juzNumber is invalid.
  ///
  /// Example:
  /// ```dart
  /// final juz = await QuranService.getJuz(1);
  /// print('Juz 1 contains ${juz.totalAyat} ayat');
  /// ```
  static Future<JuzResult> getJuz(int juzNumber) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateJuzNumber(juzNumber);

    final List<AyahWithSurah> juzAyat = [];

    for (final surah in _quranData!.surahs) {
      for (final ayah in surah.ayat) {
        if (ayah.juz == juzNumber) {
          juzAyat.add(AyahWithSurah(
            id: ayah.id,
            text: ayah.text,
            sajdah: ayah.sajdah,
            juz: ayah.juz,
            hizb: ayah.hizb,
            surah: surah,
          ));
        }
      }
    }

    return JuzResult(
      juz: juzNumber,
      totalAyat: juzAyat.length,
      ayat: juzAyat,
    );
  }

  /// Get all ayat from a specific Hizb.
  ///
  /// [hizbNumber] The Hizb number (1-60)
  ///
  /// Returns [HizbResult] containing all ayat in the specified Hizb.
  ///
  /// Throws [ArgumentError] if hizbNumber is invalid.
  ///
  /// Example:
  /// ```dart
  /// final hizb = await QuranService.getHizb(1);
  /// print('Hizb 1 contains ${hizb.totalAyat} ayat');
  /// ```
  static Future<HizbResult> getHizb(int hizbNumber) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateHizbNumber(hizbNumber);

    final List<AyahWithSurah> hizbAyat = [];

    for (final surah in _quranData!.surahs) {
      for (final ayah in surah.ayat) {
        if (ayah.hizb == hizbNumber) {
          hizbAyat.add(AyahWithSurah(
            id: ayah.id,
            text: ayah.text,
            sajdah: ayah.sajdah,
            juz: ayah.juz,
            hizb: ayah.hizb,
            surah: surah,
          ));
        }
      }
    }

    final juzNumber = ((hizbNumber - 1) ~/ 2) + 1;

    return HizbResult(
      hizb: hizbNumber,
      juz: juzNumber,
      totalAyat: hizbAyat.length,
      ayat: hizbAyat,
    );
  }

  /// Search for surahs by Arabic or English name.
  ///
  /// [name] Surah name to search for (supports partial matching)
  ///
  /// Returns [SurahSearchResult] containing matching surahs.
  ///
  /// Throws [ArgumentError] if name is empty.
  ///
  /// Example:
  /// ```dart
  /// final results = await QuranService.searchBySurahName('Fatiha');
  /// print('Found: ${results.results.first.englishName}');
  /// ```
  static Future<SurahSearchResult> searchBySurahName(String name) async {
    await initialize();
    _ensureDataLoaded();

    QuranValidators.validateSearchTerm(name);

    final searchTerm = name.toLowerCase().trim();
    final List<Surah> matchingSurahs = [];

    for (final surah in _quranData!.surahs) {
      final englishNameLower = surah.englishName.toLowerCase();
      final arabicName = surah.name;

      if (englishNameLower.contains(searchTerm) || arabicName.contains(name)) {
        matchingSurahs.add(surah);
      }
    }

    return SurahSearchResult(
      searchTerm: name,
      totalResults: matchingSurahs.length,
      results: matchingSurahs,
    );
  }

  /// Get comprehensive statistics about the Quran.
  ///
  /// Returns [SurahStatistics] containing detailed analytics.
  ///
  /// Example:
  /// ```dart
  /// final stats = await QuranService.getSurahStatistics();
  /// print('${stats.totalSurahs} surahs, ${stats.totalAyat} ayat');
  /// ```
  static Future<SurahStatistics> getSurahStatistics() async {
    await initialize();
    _ensureDataLoaded();

    final surahs = _quranData!.surahs;

    // Basic counts
    final totalSurahs = surahs.length;
    final totalAyat =
        surahs.fold<int>(0, (sum, surah) => sum + surah.numberOfAyahs);
    final meccanSurahs = surahs.where((s) => s.isMeccan).length;
    final medinanSurahs = surahs.where((s) => s.isMedianan).length;

    // Find extremes
    final longestSurah = surahs.reduce(
        (curr, next) => curr.numberOfAyahs > next.numberOfAyahs ? curr : next);
    final shortestSurah = surahs.reduce(
        (curr, next) => curr.numberOfAyahs < next.numberOfAyahs ? curr : next);

    // Calculate averages
    final averageAyatPerSurah = totalAyat / totalSurahs;

    // Create distribution map
    final Map<int, int> distribution = {};
    for (final surah in surahs) {
      distribution[surah.numberOfAyahs] =
          (distribution[surah.numberOfAyahs] ?? 0) + 1;
    }

    // Find mode (most common length)
    final mode = distribution.entries
        .reduce((curr, next) => curr.value > next.value ? curr : next)
        .key;

    // Calculate revelation analysis
    final meccanAyat = surahs
        .where((s) => s.isMeccan)
        .fold<int>(0, (sum, s) => sum + s.numberOfAyahs);
    final medinanAyat = surahs
        .where((s) => s.isMedianan)
        .fold<int>(0, (sum, s) => sum + s.numberOfAyahs);

    final meccanLengths =
        surahs.where((s) => s.isMeccan).map((s) => s.numberOfAyahs).toList();
    final medinanLengths =
        surahs.where((s) => s.isMedianan).map((s) => s.numberOfAyahs).toList();

    return SurahStatistics(
      totalSurahs: totalSurahs,
      totalAyat: totalAyat,
      meccanSurahs: meccanSurahs,
      medinanSurahs: medinanSurahs,
      averageAyatPerSurah: averageAyatPerSurah,
      longestSurah: longestSurah,
      shortestSurah: shortestSurah,
      ayatCounts: AyatCounts(
        min: shortestSurah.numberOfAyahs,
        max: longestSurah.numberOfAyahs,
        median: _calculateMedian(surahs.map((s) => s.numberOfAyahs).toList()),
        mode: mode,
        distribution: distribution,
      ),
      revelationAnalysis: RevelationAnalysis(
        meccanCharacteristics: RevelationCharacteristics(
          averageLength: meccanLengths.isNotEmpty
              ? meccanLengths.reduce((a, b) => a + b) / meccanLengths.length
              : 0,
          totalAyat: meccanAyat,
          shortestLength: meccanLengths.isNotEmpty
              ? meccanLengths.reduce((a, b) => a < b ? a : b)
              : 0,
          longestLength: meccanLengths.isNotEmpty
              ? meccanLengths.reduce((a, b) => a > b ? a : b)
              : 0,
        ),
        medinanCharacteristics: RevelationCharacteristics(
          averageLength: medinanLengths.isNotEmpty
              ? medinanLengths.reduce((a, b) => a + b) / medinanLengths.length
              : 0,
          totalAyat: medinanAyat,
          shortestLength: medinanLengths.isNotEmpty
              ? medinanLengths.reduce((a, b) => a < b ? a : b)
              : 0,
          longestLength: medinanLengths.isNotEmpty
              ? medinanLengths.reduce((a, b) => a > b ? a : b)
              : 0,
        ),
      ),
    );
  }

  /// Calculate median value from a list of numbers
  static double _calculateMedian(List<int> numbers) {
    final sorted = List<int>.from(numbers)..sort();
    final length = sorted.length;

    if (length % 2 == 0) {
      return (sorted[length ~/ 2 - 1] + sorted[length ~/ 2]) / 2;
    } else {
      return sorted[length ~/ 2].toDouble();
    }
  }
}

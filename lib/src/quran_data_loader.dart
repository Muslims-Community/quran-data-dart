import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/quran_data.dart';

/// Handles loading and parsing of Quran data from assets.
class QuranDataLoader {
  static QuranData? _cachedData;

  /// Load Quran data from assets
  static Future<QuranData> loadQuranData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      // Load JSON data from assets
      final String jsonString = await rootBundle.loadString('assets/quran.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      _cachedData = QuranData.fromJson(jsonData);
      return _cachedData!;
    } catch (e) {
      throw Exception('Failed to load Quran data: $e');
    }
  }

  /// Load Quran data from a file (for testing or custom data sources)
  static Future<QuranData> loadQuranDataFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final String jsonString = await file.readAsString();
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      return QuranData.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load Quran data from file: $e');
    }
  }

  /// Clear cached data (useful for testing)
  static void clearCache() {
    _cachedData = null;
  }

  /// Check if data is cached
  static bool get isDataCached => _cachedData != null;

  /// Get cached data without loading (returns null if not cached)
  static QuranData? get cachedData => _cachedData;

  /// Validate the loaded data structure
  static bool validateQuranData(QuranData data) {
    try {
      // Check basic structure
      if (data.surahs.length != 114) {
        return false;
      }

      // Check total ayat count
      final totalAyat = data.surahs.fold<int>(0, (sum, surah) => sum + surah.numberOfAyahs);
      if (totalAyat != 6236) {
        return false;
      }

      // Check surah ordering
      for (int i = 0; i < data.surahs.length; i++) {
        if (data.surahs[i].id != i + 1) {
          return false;
        }
      }

      // Check ayah ordering within surahs
      for (final surah in data.surahs) {
        if (surah.ayat.length != surah.numberOfAyahs) {
          return false;
        }

        for (int i = 0; i < surah.ayat.length; i++) {
          if (surah.ayat[i].id != i + 1) {
            return false;
          }
        }
      }

      // Check Juz and Hizb mappings
      final juzSet = <int>{};
      final hizbSet = <int>{};

      for (final surah in data.surahs) {
        for (final ayah in surah.ayat) {
          if (ayah.juz < 1 || ayah.juz > 30) {
            return false;
          }
          if (ayah.hizb < 1 || ayah.hizb > 60) {
            return false;
          }

          juzSet.add(ayah.juz);
          hizbSet.add(ayah.hizb);
        }
      }

      // Should have all 30 Juz and 60 Hizb
      if (juzSet.length != 30 || hizbSet.length != 60) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get data loading statistics
  static Future<DataLoadingStats> getLoadingStats() async {
    final stopwatch = Stopwatch()..start();

    try {
      final data = await loadQuranData();
      stopwatch.stop();

      // Calculate statistics
      final totalSurahs = data.surahs.length;
      final totalAyat = data.surahs.fold<int>(0, (sum, surah) => sum + surah.numberOfAyahs);
      final totalCharacters = data.surahs.fold<int>(0, (sum, surah) =>
          sum + surah.ayat.fold<int>(0, (ayahSum, ayah) => ayahSum + ayah.text.length));

      final meccanSurahs = data.surahs.where((s) => s.isMeccan).length;
      final medinanSurahs = data.surahs.where((s) => s.isMedianan).length;
      final sajdahAyat = data.surahs.fold<int>(0, (sum, surah) =>
          sum + surah.ayat.where((ayah) => ayah.sajdah).length);

      return DataLoadingStats(
        loadingTimeMs: stopwatch.elapsedMilliseconds,
        totalSurahs: totalSurahs,
        totalAyat: totalAyat,
        totalCharacters: totalCharacters,
        meccanSurahs: meccanSurahs,
        medinanSurahs: medinanSurahs,
        sajdahAyat: sajdahAyat,
        isValid: validateQuranData(data),
        dataSize: totalCharacters * 2, // Approximate size in bytes (UTF-16)
      );
    } catch (e) {
      stopwatch.stop();
      throw Exception('Failed to get loading stats: $e');
    }
  }
}

/// Statistics about data loading performance and content.
class DataLoadingStats {
  /// Time taken to load data in milliseconds
  final int loadingTimeMs;

  /// Total number of surahs
  final int totalSurahs;

  /// Total number of ayat
  final int totalAyat;

  /// Total number of characters in Arabic text
  final int totalCharacters;

  /// Number of Meccan surahs
  final int meccanSurahs;

  /// Number of Medinan surahs
  final int medinanSurahs;

  /// Number of sajdah ayat
  final int sajdahAyat;

  /// Whether the data structure is valid
  final bool isValid;

  /// Approximate data size in bytes
  final int dataSize;

  const DataLoadingStats({
    required this.loadingTimeMs,
    required this.totalSurahs,
    required this.totalAyat,
    required this.totalCharacters,
    required this.meccanSurahs,
    required this.medinanSurahs,
    required this.sajdahAyat,
    required this.isValid,
    required this.dataSize,
  });

  /// Data size in KB
  double get dataSizeKB => dataSize / 1024;

  /// Data size in MB
  double get dataSizeMB => dataSizeKB / 1024;

  /// Loading speed in ayat per millisecond
  double get loadingSpeed => totalAyat / loadingTimeMs;

  @override
  String toString() {
    return 'DataLoadingStats{'
        'loadingTime: ${loadingTimeMs}ms, '
        'totalSurahs: $totalSurahs, '
        'totalAyat: $totalAyat, '
        'meccan: $meccanSurahs, '
        'medinan: $medinanSurahs, '
        'sajdah: $sajdahAyat, '
        'size: ${dataSizeMB.toStringAsFixed(2)}MB, '
        'valid: $isValid'
        '}';
  }
}
import 'surah.dart';

/// Represents the complete Quran dataset.
class QuranData {
  /// Version of the data format
  final String version;

  /// Source attribution
  final String source;

  /// List of all 114 surahs
  final List<Surah> surahs;

  /// Metadata about the Quran
  final QuranMetadata metadata;

  const QuranData({
    required this.version,
    required this.source,
    required this.surahs,
    required this.metadata,
  });

  /// Creates QuranData from JSON
  factory QuranData.fromJson(Map<String, dynamic> json) {
    final surahsList = json['surahs'] as List<dynamic>;

    // Calculate metadata from surahs
    final totalAyat = surahsList.fold<int>(0, (sum, surahJson) {
      final surah = surahJson as Map<String, dynamic>;
      return sum + (surah['numberOfAyahs'] as int);
    });

    final meccanCount = surahsList.where((surahJson) {
      final surah = surahJson as Map<String, dynamic>;
      return surah['revelationType'] == 'Meccan';
    }).length;

    final medinanCount = surahsList.length - meccanCount;

    return QuranData(
      version: json['version'] as String? ?? '1.1',
      source:
          json['source'] as String? ?? 'Tanzil Project - https://tanzil.net',
      surahs: surahsList
          .map((surahJson) => Surah.fromJson(surahJson as Map<String, dynamic>))
          .toList(),
      metadata: QuranMetadata(
        totalSurahs: surahsList.length,
        totalAyat: totalAyat,
        meccanSurahs: meccanCount,
        medinanSurahs: medinanCount,
        dataVersion: json['version'] as String? ?? '1.1',
        lastUpdated: DateTime.now(), // Could be parsed from JSON if available
      ),
    );
  }

  /// Converts QuranData to JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'source': source,
      'surahs': surahs.map((surah) => surah.toJson()).toList(),
      'metadata': metadata.toJson(),
    };
  }

  /// Get a specific surah by ID
  Surah? getSurah(int surahId) {
    try {
      return surahs.firstWhere((surah) => surah.id == surahId);
    } catch (e) {
      return null;
    }
  }

  /// Get surahs by revelation type
  List<Surah> getSurahsByRevelationType(String revelationType) {
    return surahs
        .where((surah) => surah.revelationType == revelationType)
        .toList();
  }

  /// Get all Meccan surahs
  List<Surah> get meccanSurahs => getSurahsByRevelationType('Meccan');

  /// Get all Medinan surahs
  List<Surah> get medinanSurahs => getSurahsByRevelationType('Medinan');

  /// Get surahs sorted by revelation order
  List<Surah> get surahsByRevelationOrder {
    final sortedSurahs = List<Surah>.from(surahs);
    sortedSurahs.sort((a, b) => a.revelationOrder.compareTo(b.revelationOrder));
    return sortedSurahs;
  }

  /// Get surahs sorted by length (ascending)
  List<Surah> get surahsByLengthAsc {
    final sortedSurahs = List<Surah>.from(surahs);
    sortedSurahs.sort((a, b) => a.numberOfAyahs.compareTo(b.numberOfAyahs));
    return sortedSurahs;
  }

  /// Get surahs sorted by length (descending)
  List<Surah> get surahsByLengthDesc {
    final sortedSurahs = List<Surah>.from(surahs);
    sortedSurahs.sort((a, b) => b.numberOfAyahs.compareTo(a.numberOfAyahs));
    return sortedSurahs;
  }

  /// Get the longest surah
  Surah get longestSurah {
    return surahs.reduce(
        (curr, next) => curr.numberOfAyahs > next.numberOfAyahs ? curr : next);
  }

  /// Get the shortest surah
  Surah get shortestSurah {
    return surahs.reduce(
        (curr, next) => curr.numberOfAyahs < next.numberOfAyahs ? curr : next);
  }

  /// Get surahs that contain sajdah ayat
  List<Surah> get surahsWithSajdah {
    return surahs.where((surah) => surah.hasSajdah).toList();
  }

  /// Validate the data structure
  bool get isValid {
    // Check basic counts
    if (surahs.length != 114) return false;
    if (metadata.totalAyat != 6236) return false;

    // Check surah ordering
    for (int i = 0; i < surahs.length; i++) {
      if (surahs[i].id != i + 1) return false;
    }

    // Check that each surah has correct ayat count
    for (final surah in surahs) {
      if (surah.ayat.length != surah.numberOfAyahs) return false;
    }

    return true;
  }

  /// Get summary statistics
  DataSummary get summary {
    final totalCharacters = surahs.fold<int>(
        0,
        (sum, surah) =>
            sum +
            surah.ayat
                .fold<int>(0, (ayahSum, ayah) => ayahSum + ayah.text.length));

    final sajdahCount =
        surahs.fold<int>(0, (sum, surah) => sum + surah.sajdahAyat.length);

    return DataSummary(
      totalSurahs: metadata.totalSurahs,
      totalAyat: metadata.totalAyat,
      totalCharacters: totalCharacters,
      meccanSurahs: metadata.meccanSurahs,
      medinanSurahs: metadata.medinanSurahs,
      sajdahAyat: sajdahCount,
      longestSurahName: longestSurah.englishName,
      shortestSurahName: shortestSurah.englishName,
      averageAyatPerSurah: metadata.totalAyat / metadata.totalSurahs,
    );
  }

  @override
  String toString() {
    return 'QuranData{version: $version, totalSurahs: ${metadata.totalSurahs}, totalAyat: ${metadata.totalAyat}}';
  }
}

/// Metadata about the Quran dataset.
class QuranMetadata {
  /// Total number of surahs
  final int totalSurahs;

  /// Total number of ayat
  final int totalAyat;

  /// Number of Meccan surahs
  final int meccanSurahs;

  /// Number of Medinan surahs
  final int medinanSurahs;

  /// Version of the data
  final String dataVersion;

  /// When the data was last updated
  final DateTime lastUpdated;

  const QuranMetadata({
    required this.totalSurahs,
    required this.totalAyat,
    required this.meccanSurahs,
    required this.medinanSurahs,
    required this.dataVersion,
    required this.lastUpdated,
  });

  /// Creates QuranMetadata from JSON
  factory QuranMetadata.fromJson(Map<String, dynamic> json) {
    return QuranMetadata(
      totalSurahs: json['totalSurahs'] as int,
      totalAyat: json['totalAyat'] as int,
      meccanSurahs: json['meccanSurahs'] as int,
      medinanSurahs: json['medinanSurahs'] as int,
      dataVersion: json['dataVersion'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// Converts QuranMetadata to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSurahs': totalSurahs,
      'totalAyat': totalAyat,
      'meccanSurahs': meccanSurahs,
      'medinanSurahs': medinanSurahs,
      'dataVersion': dataVersion,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Percentage of Meccan surahs
  double get meccanPercentage => (meccanSurahs / totalSurahs) * 100;

  /// Percentage of Medinan surahs
  double get medinanPercentage => (medinanSurahs / totalSurahs) * 100;

  /// Average ayat per surah
  double get averageAyatPerSurah => totalAyat / totalSurahs;

  @override
  String toString() {
    return 'QuranMetadata{totalSurahs: $totalSurahs, totalAyat: $totalAyat, version: $dataVersion}';
  }
}

/// Summary statistics about the Quran data.
class DataSummary {
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

  /// Name of the longest surah
  final String longestSurahName;

  /// Name of the shortest surah
  final String shortestSurahName;

  /// Average ayat per surah
  final double averageAyatPerSurah;

  const DataSummary({
    required this.totalSurahs,
    required this.totalAyat,
    required this.totalCharacters,
    required this.meccanSurahs,
    required this.medinanSurahs,
    required this.sajdahAyat,
    required this.longestSurahName,
    required this.shortestSurahName,
    required this.averageAyatPerSurah,
  });

  /// Data size in bytes (approximate)
  int get dataSizeBytes => totalCharacters * 2; // UTF-16 encoding

  /// Data size in kilobytes
  double get dataSizeKB => dataSizeBytes / 1024;

  /// Data size in megabytes
  double get dataSizeMB => dataSizeKB / 1024;

  /// Estimated reading time in minutes (2 ayat/minute)
  double get estimatedReadingMinutes => totalAyat / 2.0;

  /// Estimated reading time in hours
  double get estimatedReadingHours => estimatedReadingMinutes / 60.0;

  @override
  String toString() {
    return 'DataSummary{surahs: $totalSurahs, ayat: $totalAyat, characters: $totalCharacters, size: ${dataSizeMB.toStringAsFixed(2)}MB}';
  }
}

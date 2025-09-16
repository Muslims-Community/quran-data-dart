import 'ayah.dart';

/// Represents the result of getting all sajdah (prostration) ayat.
class SajdahResult {
  /// Total number of sajdah ayat in the Quran (15)
  final int totalSajdahAyat;

  /// List of all sajdah ayat
  final List<AyahWithSurah> sajdahAyat;

  /// Source attribution for the Quran text
  final String source;

  const SajdahResult({
    required this.totalSajdahAyat,
    required this.sajdahAyat,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a SajdahResult from JSON data
  factory SajdahResult.fromJson(Map<String, dynamic> json) {
    final sajdahAyatList = json['sajdahAyat'] as List<dynamic>;

    return SajdahResult(
      totalSajdahAyat: json['totalSajdahAyat'] as int,
      sajdahAyat: sajdahAyatList
          .map((ayahJson) => AyahWithSurah.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the SajdahResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSajdahAyat': totalSajdahAyat,
      'sajdahAyat': sajdahAyat.map((ayah) => ayah.toJson()).toList(),
      'source': source,
    };
  }

  /// Get sajdah ayat from a specific surah
  List<AyahWithSurah> getSajdahFromSurah(int surahId) {
    return sajdahAyat.where((ayah) => ayah.surah.id == surahId).toList();
  }

  /// Get sajdah ayat by revelation type
  List<AyahWithSurah> getSajdahByRevelationType(String revelationType) {
    return sajdahAyat.where((ayah) => ayah.surah.revelationType == revelationType).toList();
  }

  /// Get Meccan sajdah ayat
  List<AyahWithSurah> get meccanSajdahAyat {
    return sajdahAyat.where((ayah) => ayah.surah.isMeccan).toList();
  }

  /// Get Medinan sajdah ayat
  List<AyahWithSurah> get medinanSajdahAyat {
    return sajdahAyat.where((ayah) => ayah.surah.isMedianan).toList();
  }

  /// Get sajdah ayat from a specific Juz
  List<AyahWithSurah> getSajdahFromJuz(int juzNumber) {
    return sajdahAyat.where((ayah) => ayah.juz == juzNumber).toList();
  }

  /// Get sajdah ayat from a specific Hizb
  List<AyahWithSurah> getSajdahFromHizb(int hizbNumber) {
    return sajdahAyat.where((ayah) => ayah.hizb == hizbNumber).toList();
  }

  /// Get unique surahs that contain sajdah ayat
  List<int> get surahsWithSajdah {
    final surahIds = sajdahAyat.map((ayah) => ayah.surah.id).toSet();
    return surahIds.toList()..sort();
  }

  /// Get unique Juz that contain sajdah ayat
  List<int> get juzWithSajdah {
    final juzNumbers = sajdahAyat.map((ayah) => ayah.juz).toSet();
    return juzNumbers.toList()..sort();
  }

  /// Group sajdah ayat by surah
  Map<int, List<AyahWithSurah>> groupBySurah() {
    final Map<int, List<AyahWithSurah>> grouped = {};

    for (final ayah in sajdahAyat) {
      grouped.putIfAbsent(ayah.surah.id, () => []).add(ayah);
    }

    return grouped;
  }

  /// Group sajdah ayat by Juz
  Map<int, List<AyahWithSurah>> groupByJuz() {
    final Map<int, List<AyahWithSurah>> grouped = {};

    for (final ayah in sajdahAyat) {
      grouped.putIfAbsent(ayah.juz, () => []).add(ayah);
    }

    return grouped;
  }

  /// Group sajdah ayat by revelation type
  Map<String, List<AyahWithSurah>> groupByRevelationType() {
    final Map<String, List<AyahWithSurah>> grouped = {};

    for (final ayah in sajdahAyat) {
      grouped.putIfAbsent(ayah.surah.revelationType, () => []).add(ayah);
    }

    return grouped;
  }

  /// Get statistics about sajdah ayat distribution
  SajdahStatistics get statistics {
    final surahCounts = <int, int>{};
    final juzCounts = <int, int>{};
    int meccanCount = 0;
    int medinanCount = 0;

    for (final ayah in sajdahAyat) {
      surahCounts[ayah.surah.id] = (surahCounts[ayah.surah.id] ?? 0) + 1;
      juzCounts[ayah.juz] = (juzCounts[ayah.juz] ?? 0) + 1;

      if (ayah.surah.isMeccan) {
        meccanCount++;
      } else {
        medinanCount++;
      }
    }

    return SajdahStatistics(
      totalSajdahAyat: totalSajdahAyat,
      uniqueSurahs: surahCounts.length,
      uniqueJuz: juzCounts.length,
      meccanSajdah: meccanCount,
      medinanSajdah: medinanCount,
      surahDistribution: surahCounts,
      juzDistribution: juzCounts,
    );
  }

  /// Whether all expected sajdah ayat are present (should be 15)
  bool get isComplete => totalSajdahAyat == 15;

  /// Get the first sajdah ayah (by Mushaf order)
  AyahWithSurah? get firstSajdah => sajdahAyat.isNotEmpty ? sajdahAyat.first : null;

  /// Get the last sajdah ayah (by Mushaf order)
  AyahWithSurah? get lastSajdah => sajdahAyat.isNotEmpty ? sajdahAyat.last : null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SajdahResult &&
          runtimeType == other.runtimeType &&
          totalSajdahAyat == other.totalSajdahAyat &&
          source == other.source;

  @override
  int get hashCode => totalSajdahAyat.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'SajdahResult{totalSajdahAyat: $totalSajdahAyat, ayatCount: ${sajdahAyat.length}}';
  }

  /// Creates a copy of this SajdahResult with the given fields replaced with new values
  SajdahResult copyWith({
    int? totalSajdahAyat,
    List<AyahWithSurah>? sajdahAyat,
    String? source,
  }) {
    return SajdahResult(
      totalSajdahAyat: totalSajdahAyat ?? this.totalSajdahAyat,
      sajdahAyat: sajdahAyat ?? this.sajdahAyat,
      source: source ?? this.source,
    );
  }
}

/// Statistics about sajdah ayat distribution.
class SajdahStatistics {
  /// Total number of sajdah ayat
  final int totalSajdahAyat;

  /// Number of unique surahs containing sajdah ayat
  final int uniqueSurahs;

  /// Number of unique Juz containing sajdah ayat
  final int uniqueJuz;

  /// Number of sajdah ayat in Meccan surahs
  final int meccanSajdah;

  /// Number of sajdah ayat in Medinan surahs
  final int medinanSajdah;

  /// Distribution of sajdah ayat by surah ID
  final Map<int, int> surahDistribution;

  /// Distribution of sajdah ayat by Juz number
  final Map<int, int> juzDistribution;

  const SajdahStatistics({
    required this.totalSajdahAyat,
    required this.uniqueSurahs,
    required this.uniqueJuz,
    required this.meccanSajdah,
    required this.medinanSajdah,
    required this.surahDistribution,
    required this.juzDistribution,
  });

  /// Percentage of sajdah ayat in Meccan surahs
  double get meccanPercentage => totalSajdahAyat > 0 ? (meccanSajdah / totalSajdahAyat) * 100 : 0;

  /// Percentage of sajdah ayat in Medinan surahs
  double get medinanPercentage => totalSajdahAyat > 0 ? (medinanSajdah / totalSajdahAyat) * 100 : 0;

  /// Average sajdah ayat per surah (among surahs that have sajdah)
  double get averagePerSurah => uniqueSurahs > 0 ? totalSajdahAyat / uniqueSurahs : 0;

  /// Average sajdah ayat per Juz (among Juz that have sajdah)
  double get averagePerJuz => uniqueJuz > 0 ? totalSajdahAyat / uniqueJuz : 0;

  /// The surah with the most sajdah ayat
  MapEntry<int, int>? get surahWithMostSajdah {
    if (surahDistribution.isEmpty) return null;

    return surahDistribution.entries.reduce(
      (curr, next) => curr.value > next.value ? curr : next,
    );
  }

  /// The Juz with the most sajdah ayat
  MapEntry<int, int>? get juzWithMostSajdah {
    if (juzDistribution.isEmpty) return null;

    return juzDistribution.entries.reduce(
      (curr, next) => curr.value > next.value ? curr : next,
    );
  }

  @override
  String toString() {
    return 'SajdahStatistics{totalSajdah: $totalSajdahAyat, uniqueSurahs: $uniqueSurahs, uniqueJuz: $uniqueJuz, meccan: $meccanSajdah, medinan: $medinanSajdah}';
  }
}
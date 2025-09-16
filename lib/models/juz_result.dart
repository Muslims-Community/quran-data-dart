import 'ayah.dart';

/// Represents the result of getting a complete Juz (Para).
class JuzResult {
  /// The Juz number (1-30)
  final int juz;

  /// Total number of ayat in this Juz
  final int totalAyat;

  /// List of all ayat in this Juz
  final List<AyahWithSurah> ayat;

  /// Source attribution for the Quran text
  final String source;

  const JuzResult({
    required this.juz,
    required this.totalAyat,
    required this.ayat,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a JuzResult from JSON data
  factory JuzResult.fromJson(Map<String, dynamic> json) {
    final ayatList = json['ayat'] as List<dynamic>;

    return JuzResult(
      juz: json['juz'] as int,
      totalAyat: json['totalAyat'] as int,
      ayat: ayatList
          .map((ayahJson) => AyahWithSurah.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the JuzResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'juz': juz,
      'totalAyat': totalAyat,
      'ayat': ayat.map((ayah) => ayah.toJson()).toList(),
      'source': source,
    };
  }

  /// Get ayat from a specific surah within this Juz
  List<AyahWithSurah> getAyatFromSurah(int surahId) {
    return ayat.where((ayah) => ayah.surah.id == surahId).toList();
  }

  /// Get unique surahs that appear in this Juz
  List<int> get surahsInJuz {
    final surahIds = ayat.map((ayah) => ayah.surah.id).toSet();
    return surahIds.toList()..sort();
  }

  /// Get ayat by revelation type
  List<AyahWithSurah> getAyatByRevelationType(String revelationType) {
    return ayat.where((ayah) => ayah.surah.revelationType == revelationType).toList();
  }

  /// Get all sajdah ayat in this Juz
  List<AyahWithSurah> get sajdahAyat {
    return ayat.where((ayah) => ayah.sajdah).toList();
  }

  /// Whether this Juz contains any sajdah ayat
  bool get hasSajdah => ayat.any((ayah) => ayah.sajdah);

  /// Get the first ayah of this Juz
  AyahWithSurah? get firstAyah => ayat.isNotEmpty ? ayat.first : null;

  /// Get the last ayah of this Juz
  AyahWithSurah? get lastAyah => ayat.isNotEmpty ? ayat.last : null;

  /// Estimated reading time in minutes (assuming 2 ayat per minute)
  double get estimatedReadingMinutes => totalAyat / 2.0;

  /// Get statistics about this Juz
  JuzStatistics get statistics {
    final surahCounts = <int, int>{};
    int meccanAyat = 0;
    int medinanAyat = 0;

    for (final ayah in ayat) {
      surahCounts[ayah.surah.id] = (surahCounts[ayah.surah.id] ?? 0) + 1;

      if (ayah.surah.isMeccan) {
        meccanAyat++;
      } else {
        medinanAyat++;
      }
    }

    return JuzStatistics(
      juzNumber: juz,
      totalAyat: totalAyat,
      uniqueSurahs: surahCounts.length,
      meccanAyat: meccanAyat,
      medinanAyat: medinanAyat,
      sajdahCount: sajdahAyat.length,
      surahDistribution: surahCounts,
      estimatedMinutes: estimatedReadingMinutes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JuzResult &&
          runtimeType == other.runtimeType &&
          juz == other.juz &&
          totalAyat == other.totalAyat &&
          source == other.source;

  @override
  int get hashCode => juz.hashCode ^ totalAyat.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'JuzResult{juz: $juz, totalAyat: $totalAyat, ayatCount: ${ayat.length}}';
  }

  /// Creates a copy of this JuzResult with the given fields replaced with new values
  JuzResult copyWith({
    int? juz,
    int? totalAyat,
    List<AyahWithSurah>? ayat,
    String? source,
  }) {
    return JuzResult(
      juz: juz ?? this.juz,
      totalAyat: totalAyat ?? this.totalAyat,
      ayat: ayat ?? this.ayat,
      source: source ?? this.source,
    );
  }
}

/// Statistics about a Juz.
class JuzStatistics {
  /// The Juz number
  final int juzNumber;

  /// Total number of ayat
  final int totalAyat;

  /// Number of unique surahs
  final int uniqueSurahs;

  /// Number of Meccan ayat
  final int meccanAyat;

  /// Number of Medinan ayat
  final int medinanAyat;

  /// Number of sajdah ayat
  final int sajdahCount;

  /// Distribution of ayat by surah
  final Map<int, int> surahDistribution;

  /// Estimated reading time in minutes
  final double estimatedMinutes;

  const JuzStatistics({
    required this.juzNumber,
    required this.totalAyat,
    required this.uniqueSurahs,
    required this.meccanAyat,
    required this.medinanAyat,
    required this.sajdahCount,
    required this.surahDistribution,
    required this.estimatedMinutes,
  });

  /// Percentage of Meccan ayat
  double get meccanPercentage => totalAyat > 0 ? (meccanAyat / totalAyat) * 100 : 0;

  /// Percentage of Medinan ayat
  double get medinanPercentage => totalAyat > 0 ? (medinanAyat / totalAyat) * 100 : 0;

  /// The surah with the most ayat in this Juz
  MapEntry<int, int>? get dominantSurah {
    if (surahDistribution.isEmpty) return null;

    return surahDistribution.entries.reduce(
      (curr, next) => curr.value > next.value ? curr : next,
    );
  }

  @override
  String toString() {
    return 'JuzStatistics{juz: $juzNumber, totalAyat: $totalAyat, uniqueSurahs: $uniqueSurahs, meccan: $meccanAyat, medinan: $medinanAyat, sajdah: $sajdahCount}';
  }
}
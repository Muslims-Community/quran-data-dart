import 'surah.dart';

/// Comprehensive statistics about the Quran.
class SurahStatistics {
  /// Total number of surahs (114)
  final int totalSurahs;

  /// Total number of ayat (6,236)
  final int totalAyat;

  /// Number of Meccan surahs
  final int meccanSurahs;

  /// Number of Medinan surahs
  final int medinanSurahs;

  /// Average number of ayat per surah
  final double averageAyatPerSurah;

  /// The longest surah by number of ayat
  final Surah longestSurah;

  /// The shortest surah by number of ayat
  final Surah shortestSurah;

  /// Statistics about ayat counts
  final AyatCounts ayatCounts;

  /// Analysis of revelation characteristics
  final RevelationAnalysis revelationAnalysis;

  /// Source attribution for the Quran text
  final String source;

  const SurahStatistics({
    required this.totalSurahs,
    required this.totalAyat,
    required this.meccanSurahs,
    required this.medinanSurahs,
    required this.averageAyatPerSurah,
    required this.longestSurah,
    required this.shortestSurah,
    required this.ayatCounts,
    required this.revelationAnalysis,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates SurahStatistics from JSON data
  factory SurahStatistics.fromJson(Map<String, dynamic> json) {
    return SurahStatistics(
      totalSurahs: json['totalSurahs'] as int,
      totalAyat: json['totalAyat'] as int,
      meccanSurahs: json['meccanSurahs'] as int,
      medinanSurahs: json['medinanSurahs'] as int,
      averageAyatPerSurah: (json['averageAyatPerSurah'] as num).toDouble(),
      longestSurah:
          Surah.fromJson(json['longestSurah'] as Map<String, dynamic>),
      shortestSurah:
          Surah.fromJson(json['shortestSurah'] as Map<String, dynamic>),
      ayatCounts:
          AyatCounts.fromJson(json['ayatCounts'] as Map<String, dynamic>),
      revelationAnalysis: RevelationAnalysis.fromJson(
          json['revelationAnalysis'] as Map<String, dynamic>),
      source:
          json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts SurahStatistics to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSurahs': totalSurahs,
      'totalAyat': totalAyat,
      'meccanSurahs': meccanSurahs,
      'medinanSurahs': medinanSurahs,
      'averageAyatPerSurah': averageAyatPerSurah,
      'longestSurah': longestSurah.toJson(),
      'shortestSurah': shortestSurah.toJson(),
      'ayatCounts': ayatCounts.toJson(),
      'revelationAnalysis': revelationAnalysis.toJson(),
      'source': source,
    };
  }

  /// Percentage of Meccan surahs
  double get meccanPercentage => (meccanSurahs / totalSurahs) * 100;

  /// Percentage of Medinan surahs
  double get medinanPercentage => (medinanSurahs / totalSurahs) * 100;

  /// Length difference ratio between longest and shortest surah
  double get lengthDifferenceRatio =>
      longestSurah.numberOfAyahs / shortestSurah.numberOfAyahs;

  /// Estimated reading time for complete Quran (in minutes, at 2 ayat/minute)
  double get totalReadingMinutes => totalAyat / 2.0;

  /// Estimated reading time for complete Quran (in hours)
  double get totalReadingHours => totalReadingMinutes / 60.0;

  /// Daily reading time for 30-day completion (in minutes)
  double get dailyReadingMinutes => totalReadingMinutes / 30.0;

  @override
  String toString() {
    return 'SurahStatistics{totalSurahs: $totalSurahs, totalAyat: $totalAyat, meccan: $meccanSurahs, medinan: $medinanSurahs, avgAyat: ${averageAyatPerSurah.toStringAsFixed(1)}}';
  }
}

/// Statistics about ayat counts and distribution.
class AyatCounts {
  /// Minimum number of ayat in any surah
  final int min;

  /// Maximum number of ayat in any surah
  final int max;

  /// Median number of ayat across all surahs
  final double median;

  /// Most common number of ayat (mode)
  final int mode;

  /// Distribution of surah lengths (ayat count -> number of surahs)
  final Map<int, int> distribution;

  const AyatCounts({
    required this.min,
    required this.max,
    required this.median,
    required this.mode,
    required this.distribution,
  });

  /// Creates AyatCounts from JSON data
  factory AyatCounts.fromJson(Map<String, dynamic> json) {
    final distributionJson = json['distribution'] as Map<String, dynamic>;
    final distribution = distributionJson.map(
      (key, value) => MapEntry(int.parse(key), value as int),
    );

    return AyatCounts(
      min: json['min'] as int,
      max: json['max'] as int,
      median: (json['median'] as num).toDouble(),
      mode: json['mode'] as int,
      distribution: distribution,
    );
  }

  /// Converts AyatCounts to JSON
  Map<String, dynamic> toJson() {
    final distributionJson = distribution.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    return {
      'min': min,
      'max': max,
      'median': median,
      'mode': mode,
      'distribution': distributionJson,
    };
  }

  /// Range of ayat counts (max - min)
  int get range => max - min;

  /// Number of unique surah lengths
  int get uniqueLengths => distribution.length;

  /// Get surahs by length category
  Map<String, int> get lengthCategories {
    int veryShort = 0; // 1-10 ayat
    int short = 0; // 11-50 ayat
    int medium = 0; // 51-100 ayat
    int long = 0; // 101-200 ayat
    int veryLong = 0; // 200+ ayat

    distribution.forEach((ayatCount, surahCount) {
      if (ayatCount <= 10) {
        veryShort += surahCount;
      } else if (ayatCount <= 50) {
        short += surahCount;
      } else if (ayatCount <= 100) {
        medium += surahCount;
      } else if (ayatCount <= 200) {
        long += surahCount;
      } else {
        veryLong += surahCount;
      }
    });

    return {
      'veryShort': veryShort,
      'short': short,
      'medium': medium,
      'long': long,
      'veryLong': veryLong,
    };
  }

  @override
  String toString() {
    return 'AyatCounts{min: $min, max: $max, median: $median, mode: $mode, uniqueLengths: $uniqueLengths}';
  }
}

/// Analysis of revelation characteristics (Meccan vs Medinan).
class RevelationAnalysis {
  /// Characteristics of Meccan surahs
  final RevelationCharacteristics meccanCharacteristics;

  /// Characteristics of Medinan surahs
  final RevelationCharacteristics medinanCharacteristics;

  const RevelationAnalysis({
    required this.meccanCharacteristics,
    required this.medinanCharacteristics,
  });

  /// Creates RevelationAnalysis from JSON data
  factory RevelationAnalysis.fromJson(Map<String, dynamic> json) {
    return RevelationAnalysis(
      meccanCharacteristics: RevelationCharacteristics.fromJson(
        json['meccanCharacteristics'] as Map<String, dynamic>,
      ),
      medinanCharacteristics: RevelationCharacteristics.fromJson(
        json['medinanCharacteristics'] as Map<String, dynamic>,
      ),
    );
  }

  /// Converts RevelationAnalysis to JSON
  Map<String, dynamic> toJson() {
    return {
      'meccanCharacteristics': meccanCharacteristics.toJson(),
      'medinanCharacteristics': medinanCharacteristics.toJson(),
    };
  }

  /// Ratio of Meccan to Medinan average length
  double get lengthRatio =>
      meccanCharacteristics.averageLength /
      medinanCharacteristics.averageLength;

  /// Difference in average length
  double get lengthDifference =>
      medinanCharacteristics.averageLength -
      meccanCharacteristics.averageLength;

  @override
  String toString() {
    return 'RevelationAnalysis{meccanAvg: ${meccanCharacteristics.averageLength.toStringAsFixed(1)}, medinanAvg: ${medinanCharacteristics.averageLength.toStringAsFixed(1)}}';
  }
}

/// Characteristics of surahs from a specific revelation period.
class RevelationCharacteristics {
  /// Average length of surahs in this category
  final double averageLength;

  /// Total ayat in this category
  final int totalAyat;

  /// Shortest surah length in this category
  final int shortestLength;

  /// Longest surah length in this category
  final int longestLength;

  const RevelationCharacteristics({
    required this.averageLength,
    required this.totalAyat,
    required this.shortestLength,
    required this.longestLength,
  });

  /// Creates RevelationCharacteristics from JSON data
  factory RevelationCharacteristics.fromJson(Map<String, dynamic> json) {
    return RevelationCharacteristics(
      averageLength: (json['averageLength'] as num).toDouble(),
      totalAyat: json['totalAyat'] as int,
      shortestLength: json['shortestLength'] as int,
      longestLength: json['longestLength'] as int,
    );
  }

  /// Converts RevelationCharacteristics to JSON
  Map<String, dynamic> toJson() {
    return {
      'averageLength': averageLength,
      'totalAyat': totalAyat,
      'shortestLength': shortestLength,
      'longestLength': longestLength,
    };
  }

  /// Range of lengths in this category
  int get lengthRange => longestLength - shortestLength;

  /// Length variation ratio
  double get lengthVariationRatio => longestLength / shortestLength;

  @override
  String toString() {
    return 'RevelationCharacteristics{avg: ${averageLength.toStringAsFixed(1)}, total: $totalAyat, range: $shortestLength-$longestLength}';
  }
}

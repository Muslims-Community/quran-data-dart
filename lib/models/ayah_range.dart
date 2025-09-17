import 'ayah.dart';
import 'surah.dart';

/// Represents a range of consecutive ayat from a specific surah.
class AyahRange {
  /// The surah this range belongs to
  final Surah surah;

  /// Information about the range
  final AyahRangeInfo range;

  /// List of ayat in this range
  final List<Ayah> ayat;

  /// Source attribution for the Quran text
  final String source;

  const AyahRange({
    required this.surah,
    required this.range,
    required this.ayat,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates an AyahRange from JSON data
  factory AyahRange.fromJson(Map<String, dynamic> json) {
    final ayatList = json['ayat'] as List<dynamic>;

    return AyahRange(
      surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
      range: AyahRangeInfo.fromJson(json['range'] as Map<String, dynamic>),
      ayat: ayatList
          .map((ayahJson) => Ayah.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
      source:
          json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the AyahRange to JSON
  Map<String, dynamic> toJson() {
    return {
      'surah': surah.toJson(),
      'range': range.toJson(),
      'ayat': ayat.map((ayah) => ayah.toJson()).toList(),
      'source': source,
    };
  }

  /// Get all sajdah ayat in this range
  List<Ayah> get sajdahAyat => ayat.where((ayah) => ayah.sajdah).toList();

  /// Whether this range contains any sajdah ayat
  bool get hasSajdah => ayat.any((ayah) => ayah.sajdah);

  /// Get unique Juz numbers in this range
  Set<int> get juzNumbers => ayat.map((ayah) => ayah.juz).toSet();

  /// Get unique Hizb numbers in this range
  Set<int> get hizbNumbers => ayat.map((ayah) => ayah.hizb).toSet();

  /// Whether this range spans multiple Juz
  bool get spansMultipleJuz => juzNumbers.length > 1;

  /// Whether this range spans multiple Hizb
  bool get spansMultipleHizb => hizbNumbers.length > 1;

  /// Estimated reading time in minutes (assuming 2 ayat per minute)
  double get estimatedReadingMinutes => range.count / 2.0;

  /// Get ayat grouped by Juz
  Map<int, List<Ayah>> get ayatByJuz {
    final Map<int, List<Ayah>> grouped = {};

    for (final ayah in ayat) {
      grouped.putIfAbsent(ayah.juz, () => []).add(ayah);
    }

    return grouped;
  }

  /// Get ayat grouped by Hizb
  Map<int, List<Ayah>> get ayatByHizb {
    final Map<int, List<Ayah>> grouped = {};

    for (final ayah in ayat) {
      grouped.putIfAbsent(ayah.hizb, () => []).add(ayah);
    }

    return grouped;
  }

  /// Get the first ayah in this range
  Ayah? get firstAyah => ayat.isNotEmpty ? ayat.first : null;

  /// Get the last ayah in this range
  Ayah? get lastAyah => ayat.isNotEmpty ? ayat.last : null;

  /// Whether this range is the complete surah
  bool get isCompleteSurah => range.count == surah.numberOfAyahs;

  /// Whether this range is just a single ayah
  bool get isSingleAyah => range.count == 1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahRange &&
          runtimeType == other.runtimeType &&
          surah == other.surah &&
          range == other.range &&
          source == other.source;

  @override
  int get hashCode => surah.hashCode ^ range.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'AyahRange{surah: ${surah.englishName}, range: ${range.start}-${range.end} (${range.count} ayat)}';
  }

  /// Creates a copy of this AyahRange with the given fields replaced with new values
  AyahRange copyWith({
    Surah? surah,
    AyahRangeInfo? range,
    List<Ayah>? ayat,
    String? source,
  }) {
    return AyahRange(
      surah: surah ?? this.surah,
      range: range ?? this.range,
      ayat: ayat ?? this.ayat,
      source: source ?? this.source,
    );
  }
}

/// Information about an ayah range.
class AyahRangeInfo {
  /// Starting ayah number (inclusive)
  final int start;

  /// Ending ayah number (inclusive)
  final int end;

  /// Total number of ayat in the range
  final int count;

  const AyahRangeInfo({
    required this.start,
    required this.end,
    required this.count,
  });

  /// Creates an AyahRangeInfo from JSON data
  factory AyahRangeInfo.fromJson(Map<String, dynamic> json) {
    return AyahRangeInfo(
      start: json['start'] as int,
      end: json['end'] as int,
      count: json['count'] as int,
    );
  }

  /// Converts the AyahRangeInfo to JSON
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
      'count': count,
    };
  }

  /// Whether this is a single ayah range
  bool get isSingleAyah => count == 1;

  /// Whether this range is valid
  bool get isValid => start <= end && count == (end - start + 1) && start > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AyahRangeInfo &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          count == other.count;

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ count.hashCode;

  @override
  String toString() {
    return 'AyahRangeInfo{start: $start, end: $end, count: $count}';
  }

  /// Creates a copy of this AyahRangeInfo with the given fields replaced with new values
  AyahRangeInfo copyWith({
    int? start,
    int? end,
    int? count,
  }) {
    return AyahRangeInfo(
      start: start ?? this.start,
      end: end ?? this.end,
      count: count ?? this.count,
    );
  }
}

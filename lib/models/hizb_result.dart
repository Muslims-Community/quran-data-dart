import 'ayah.dart';

/// Represents the result of getting a complete Hizb.
class HizbResult {
  /// The Hizb number (1-60)
  final int hizb;

  /// The parent Juz number this Hizb belongs to (1-30)
  final int juz;

  /// Total number of ayat in this Hizb
  final int totalAyat;

  /// List of all ayat in this Hizb
  final List<AyahWithSurah> ayat;

  /// Source attribution for the Quran text
  final String source;

  const HizbResult({
    required this.hizb,
    required this.juz,
    required this.totalAyat,
    required this.ayat,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a HizbResult from JSON data
  factory HizbResult.fromJson(Map<String, dynamic> json) {
    final ayatList = json['ayat'] as List<dynamic>;

    return HizbResult(
      hizb: json['hizb'] as int,
      juz: json['juz'] as int,
      totalAyat: json['totalAyat'] as int,
      ayat: ayatList
          .map((ayahJson) => AyahWithSurah.fromJson(ayahJson as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the HizbResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'hizb': hizb,
      'juz': juz,
      'totalAyat': totalAyat,
      'ayat': ayat.map((ayah) => ayah.toJson()).toList(),
      'source': source,
    };
  }

  /// Whether this is the first Hizb of its Juz
  bool get isFirstHizbOfJuz => hizb % 2 == 1;

  /// Whether this is the second Hizb of its Juz
  bool get isSecondHizbOfJuz => hizb % 2 == 0;

  /// Get the companion Hizb number (the other half of the same Juz)
  int get companionHizb => isFirstHizbOfJuz ? hizb + 1 : hizb - 1;

  /// Estimated reading time in minutes (assuming 2 ayat per minute)
  double get estimatedReadingMinutes => totalAyat / 2.0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HizbResult &&
          runtimeType == other.runtimeType &&
          hizb == other.hizb &&
          juz == other.juz &&
          totalAyat == other.totalAyat &&
          source == other.source;

  @override
  int get hashCode =>
      hizb.hashCode ^ juz.hashCode ^ totalAyat.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'HizbResult{hizb: $hizb, juz: $juz, totalAyat: $totalAyat, ayatCount: ${ayat.length}}';
  }

  /// Creates a copy of this HizbResult with the given fields replaced with new values
  HizbResult copyWith({
    int? hizb,
    int? juz,
    int? totalAyat,
    List<AyahWithSurah>? ayat,
    String? source,
  }) {
    return HizbResult(
      hizb: hizb ?? this.hizb,
      juz: juz ?? this.juz,
      totalAyat: totalAyat ?? this.totalAyat,
      ayat: ayat ?? this.ayat,
      source: source ?? this.source,
    );
  }
}
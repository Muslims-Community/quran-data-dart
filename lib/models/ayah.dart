/// Represents a single ayah (verse) from the Quran.
class Ayah {
  /// The ayah number within its surah
  final int id;

  /// The Arabic text of the ayah
  final String text;

  /// Whether this ayah requires sajdah (prostration)
  final bool sajdah;

  /// The Juz (Para) number this ayah belongs to (1-30)
  final int juz;

  /// The Hizb number this ayah belongs to (1-60)
  final int hizb;

  const Ayah({
    required this.id,
    required this.text,
    required this.sajdah,
    required this.juz,
    required this.hizb,
  });

  /// Creates an Ayah from JSON data
  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      id: json['id'] as int,
      text: json['text'] as String,
      sajdah: json['sajdah'] as bool? ?? false,
      juz: json['juz'] as int,
      hizb: json['hizb'] as int,
    );
  }

  /// Converts the Ayah to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sajdah': sajdah,
      'juz': juz,
      'hizb': hizb,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ayah &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          sajdah == other.sajdah &&
          juz == other.juz &&
          hizb == other.hizb;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      sajdah.hashCode ^
      juz.hashCode ^
      hizb.hashCode;

  @override
  String toString() {
    return 'Ayah{id: $id, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}${text.length > 50 ? '...' : ''}, sajdah: $sajdah, juz: $juz, hizb: $hizb}';
  }

  /// Creates a copy of this Ayah with the given fields replaced with new values
  Ayah copyWith({
    int? id,
    String? text,
    bool? sajdah,
    int? juz,
    int? hizb,
  }) {
    return Ayah(
      id: id ?? this.id,
      text: text ?? this.text,
      sajdah: sajdah ?? this.sajdah,
      juz: juz ?? this.juz,
      hizb: hizb ?? this.hizb,
    );
  }
}

/// Represents an ayah with its associated surah information.
class AyahWithSurah extends Ayah {
  /// The surah this ayah belongs to
  final Surah surah;

  /// Source attribution for the Quran text
  final String source;

  const AyahWithSurah({
    required super.id,
    required super.text,
    required super.sajdah,
    required super.juz,
    required super.hizb,
    required this.surah,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates an AyahWithSurah from JSON data
  factory AyahWithSurah.fromJson(Map<String, dynamic> json) {
    return AyahWithSurah(
      id: json['id'] as int,
      text: json['text'] as String,
      sajdah: json['sajdah'] as bool? ?? false,
      juz: json['juz'] as int,
      hizb: json['hizb'] as int,
      surah: Surah.fromJson(json['surah'] as Map<String, dynamic>),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'surah': surah.toJson(),
      'source': source,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is AyahWithSurah &&
          runtimeType == other.runtimeType &&
          surah == other.surah &&
          source == other.source;

  @override
  int get hashCode => super.hashCode ^ surah.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'AyahWithSurah{id: $id, surah: ${surah.englishName} ${surah.id}, text: ${text.substring(0, text.length > 30 ? 30 : text.length)}${text.length > 30 ? '...' : ''}, sajdah: $sajdah, juz: $juz, hizb: $hizb}';
  }

  /// Creates a copy of this AyahWithSurah with the given fields replaced with new values
  @override
  AyahWithSurah copyWith({
    int? id,
    String? text,
    bool? sajdah,
    int? juz,
    int? hizb,
    Surah? surah,
    String? source,
  }) {
    return AyahWithSurah(
      id: id ?? this.id,
      text: text ?? this.text,
      sajdah: sajdah ?? this.sajdah,
      juz: juz ?? this.juz,
      hizb: hizb ?? this.hizb,
      surah: surah ?? this.surah,
      source: source ?? this.source,
    );
  }
}

// Import surah model
import 'surah.dart';
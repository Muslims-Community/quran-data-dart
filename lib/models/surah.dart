import 'ayah.dart';

/// Represents a complete surah (chapter) from the Quran.
class Surah {
  /// The surah number in Mushaf order (1-114)
  final int id;

  /// The Arabic name of the surah
  final String name;

  /// The English name of the surah
  final String englishName;

  /// The revelation type: "Meccan" or "Medinan"
  final String revelationType;

  /// The total number of ayat in this surah
  final int numberOfAyahs;

  /// The chronological revelation order (1-114)
  final int revelationOrder;

  /// List of all ayat in this surah
  final List<Ayah> ayat;

  /// Source attribution for the Quran text
  final String source;

  const Surah({
    required this.id,
    required this.name,
    required this.englishName,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.revelationOrder,
    required this.ayat,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a Surah from JSON data
  factory Surah.fromJson(Map<String, dynamic> json) {
    final ayatList = json['ayat'] as List<dynamic>?;

    return Surah(
      id: json['id'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationOrder: json['revelationOrder'] as int,
      ayat: ayatList?.map((ayahJson) => Ayah.fromJson(ayahJson as Map<String, dynamic>)).toList() ?? [],
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the Surah to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'englishName': englishName,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'revelationOrder': revelationOrder,
      'ayat': ayat.map((ayah) => ayah.toJson()).toList(),
      'source': source,
    };
  }

  /// Creates a basic Surah without ayat (for references)
  factory Surah.basic({
    required int id,
    required String name,
    required String englishName,
    required String revelationType,
    required int numberOfAyahs,
    required int revelationOrder,
    String source = "Tanzil Project - https://tanzil.net",
  }) {
    return Surah(
      id: id,
      name: name,
      englishName: englishName,
      revelationType: revelationType,
      numberOfAyahs: numberOfAyahs,
      revelationOrder: revelationOrder,
      ayat: [],
      source: source,
    );
  }

  /// Whether this surah was revealed in Mecca
  bool get isMeccan => revelationType == 'Meccan';

  /// Whether this surah was revealed in Medina
  bool get isMedianan => revelationType == 'Medinan';

  /// Get a specific ayah by its number
  Ayah? getAyah(int ayahNumber) {
    if (ayahNumber < 1 || ayahNumber > numberOfAyahs) {
      return null;
    }

    return ayat.firstWhere(
      (ayah) => ayah.id == ayahNumber,
      orElse: () => throw ArgumentError('Ayah $ayahNumber not found in surah $id'),
    );
  }

  /// Get a range of ayat from this surah
  List<Ayah> getAyahRange(int startAyah, int endAyah) {
    if (startAyah < 1 || endAyah > numberOfAyahs || startAyah > endAyah) {
      throw ArgumentError('Invalid ayah range: $startAyah-$endAyah');
    }

    return ayat.where((ayah) => ayah.id >= startAyah && ayah.id <= endAyah).toList();
  }

  /// Get all sajdah ayat in this surah
  List<Ayah> get sajdahAyat => ayat.where((ayah) => ayah.sajdah).toList();

  /// Whether this surah contains any sajdah ayat
  bool get hasSajdah => ayat.any((ayah) => ayah.sajdah);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          englishName == other.englishName &&
          revelationType == other.revelationType &&
          numberOfAyahs == other.numberOfAyahs &&
          revelationOrder == other.revelationOrder;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      englishName.hashCode ^
      revelationType.hashCode ^
      numberOfAyahs.hashCode ^
      revelationOrder.hashCode;

  @override
  String toString() {
    return 'Surah{id: $id, name: $name, englishName: $englishName, revelationType: $revelationType, numberOfAyahs: $numberOfAyahs, revelationOrder: $revelationOrder}';
  }

  /// Creates a copy of this Surah with the given fields replaced with new values
  Surah copyWith({
    int? id,
    String? name,
    String? englishName,
    String? revelationType,
    int? numberOfAyahs,
    int? revelationOrder,
    List<Ayah>? ayat,
    String? source,
  }) {
    return Surah(
      id: id ?? this.id,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      revelationType: revelationType ?? this.revelationType,
      numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
      revelationOrder: revelationOrder ?? this.revelationOrder,
      ayat: ayat ?? this.ayat,
      source: source ?? this.source,
    );
  }
}
import 'surah.dart';

/// Represents the result of searching for surahs by name.
class SurahSearchResult {
  /// The search term that was used
  final String searchTerm;

  /// Total number of surahs that match the search term
  final int totalResults;

  /// List of surahs that match the search term
  final List<Surah> results;

  /// Source attribution for the Quran text
  final String source;

  const SurahSearchResult({
    required this.searchTerm,
    required this.totalResults,
    required this.results,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a SurahSearchResult from JSON data
  factory SurahSearchResult.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>;

    return SurahSearchResult(
      searchTerm: json['searchTerm'] as String,
      totalResults: json['totalResults'] as int,
      results: resultsList
          .map((result) => Surah.fromJson(result as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the SurahSearchResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'searchTerm': searchTerm,
      'totalResults': totalResults,
      'results': results.map((result) => result.toJson()).toList(),
      'source': source,
    };
  }

  /// Whether the search returned any results
  bool get hasResults => totalResults > 0;

  /// Whether the search returned no results
  bool get isEmpty => totalResults == 0;

  /// Get results by revelation type
  List<Surah> getResultsByRevelationType(String revelationType) {
    return results.where((surah) => surah.revelationType == revelationType).toList();
  }

  /// Get Meccan surahs from results
  List<Surah> get meccanResults =>
      results.where((surah) => surah.isMeccan).toList();

  /// Get Medinan surahs from results
  List<Surah> get medinanResults =>
      results.where((surah) => surah.isMedianan).toList();

  /// Get results sorted by revelation order
  List<Surah> get resultsByRevelationOrder {
    final sortedResults = List<Surah>.from(results);
    sortedResults.sort((a, b) => a.revelationOrder.compareTo(b.revelationOrder));
    return sortedResults;
  }

  /// Get results sorted by Mushaf order (ID)
  List<Surah> get resultsByMushafOrder {
    final sortedResults = List<Surah>.from(results);
    sortedResults.sort((a, b) => a.id.compareTo(b.id));
    return sortedResults;
  }

  /// Get results sorted by number of ayahs (ascending)
  List<Surah> get resultsByLengthAsc {
    final sortedResults = List<Surah>.from(results);
    sortedResults.sort((a, b) => a.numberOfAyahs.compareTo(b.numberOfAyahs));
    return sortedResults;
  }

  /// Get results sorted by number of ayahs (descending)
  List<Surah> get resultsByLengthDesc {
    final sortedResults = List<Surah>.from(results);
    sortedResults.sort((a, b) => b.numberOfAyahs.compareTo(a.numberOfAyahs));
    return sortedResults;
  }

  /// Get the first exact match (if any)
  Surah? get exactMatch {
    final lowerSearchTerm = searchTerm.toLowerCase();

    // Try exact English name match first
    for (final surah in results) {
      if (surah.englishName.toLowerCase() == lowerSearchTerm) {
        return surah;
      }
    }

    // Try exact Arabic name match
    for (final surah in results) {
      if (surah.name == searchTerm) {
        return surah;
      }
    }

    return null;
  }

  /// Get statistics about the search results
  SurahSearchStatistics get statistics {
    int meccanCount = 0;
    int medinanCount = 0;
    int totalAyat = 0;
    int minAyat = results.isNotEmpty ? results.first.numberOfAyahs : 0;
    int maxAyat = 0;

    for (final surah in results) {
      if (surah.isMeccan) {
        meccanCount++;
      } else {
        medinanCount++;
      }

      totalAyat += surah.numberOfAyahs;

      if (surah.numberOfAyahs < minAyat) {
        minAyat = surah.numberOfAyahs;
      }

      if (surah.numberOfAyahs > maxAyat) {
        maxAyat = surah.numberOfAyahs;
      }
    }

    final averageAyat = results.isNotEmpty ? totalAyat / results.length : 0.0;

    return SurahSearchStatistics(
      totalResults: totalResults,
      meccanResults: meccanCount,
      medinanResults: medinanCount,
      totalAyat: totalAyat,
      averageAyat: averageAyat,
      minAyat: minAyat,
      maxAyat: maxAyat,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurahSearchResult &&
          runtimeType == other.runtimeType &&
          searchTerm == other.searchTerm &&
          totalResults == other.totalResults &&
          source == other.source;

  @override
  int get hashCode =>
      searchTerm.hashCode ^ totalResults.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'SurahSearchResult{searchTerm: $searchTerm, totalResults: $totalResults, resultsCount: ${results.length}}';
  }

  /// Creates a copy of this SurahSearchResult with the given fields replaced with new values
  SurahSearchResult copyWith({
    String? searchTerm,
    int? totalResults,
    List<Surah>? results,
    String? source,
  }) {
    return SurahSearchResult(
      searchTerm: searchTerm ?? this.searchTerm,
      totalResults: totalResults ?? this.totalResults,
      results: results ?? this.results,
      source: source ?? this.source,
    );
  }
}

/// Statistics about surah search results.
class SurahSearchStatistics {
  /// Total number of results
  final int totalResults;

  /// Number of Meccan surahs in results
  final int meccanResults;

  /// Number of Medinan surahs in results
  final int medinanResults;

  /// Total ayat in all result surahs
  final int totalAyat;

  /// Average number of ayat per surah in results
  final double averageAyat;

  /// Minimum number of ayat in result surahs
  final int minAyat;

  /// Maximum number of ayat in result surahs
  final int maxAyat;

  const SurahSearchStatistics({
    required this.totalResults,
    required this.meccanResults,
    required this.medinanResults,
    required this.totalAyat,
    required this.averageAyat,
    required this.minAyat,
    required this.maxAyat,
  });

  /// Percentage of Meccan surahs in results
  double get meccanPercentage =>
      totalResults > 0 ? (meccanResults / totalResults) * 100 : 0;

  /// Percentage of Medinan surahs in results
  double get medinanPercentage =>
      totalResults > 0 ? (medinanResults / totalResults) * 100 : 0;

  @override
  String toString() {
    return 'SurahSearchStatistics{totalResults: $totalResults, meccan: $meccanResults, medinan: $medinanResults, totalAyat: $totalAyat, avgAyat: ${averageAyat.toStringAsFixed(1)}}';
  }
}
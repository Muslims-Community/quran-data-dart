import 'ayah.dart';

/// Represents the result of a text search in the Quran.
class SearchResult {
  /// The search term that was used
  final String searchTerm;

  /// Total number of ayat that contain the search term
  final int totalResults;

  /// List of ayat that contain the search term
  final List<AyahWithSurah> results;

  /// Source attribution for the Quran text
  final String source;

  const SearchResult({
    required this.searchTerm,
    required this.totalResults,
    required this.results,
    this.source = "Tanzil Project - https://tanzil.net",
  });

  /// Creates a SearchResult from JSON data
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final resultsList = json['results'] as List<dynamic>;

    return SearchResult(
      searchTerm: json['searchTerm'] as String,
      totalResults: json['totalResults'] as int,
      results: resultsList
          .map((result) => AyahWithSurah.fromJson(result as Map<String, dynamic>))
          .toList(),
      source: json['source'] as String? ?? "Tanzil Project - https://tanzil.net",
    );
  }

  /// Converts the SearchResult to JSON
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

  /// Get results limited to a specific number
  List<AyahWithSurah> limitResults(int limit) {
    return results.take(limit).toList();
  }

  /// Get results from a specific surah only
  List<AyahWithSurah> getResultsFromSurah(int surahId) {
    return results.where((ayah) => ayah.surah.id == surahId).toList();
  }

  /// Get results by revelation type
  List<AyahWithSurah> getResultsByRevelationType(String revelationType) {
    return results.where((ayah) => ayah.surah.revelationType == revelationType).toList();
  }

  /// Get results from specific Juz
  List<AyahWithSurah> getResultsFromJuz(int juzNumber) {
    return results.where((ayah) => ayah.juz == juzNumber).toList();
  }

  /// Group results by surah
  Map<int, List<AyahWithSurah>> groupBySurah() {
    final Map<int, List<AyahWithSurah>> grouped = {};

    for (final ayah in results) {
      grouped.putIfAbsent(ayah.surah.id, () => []).add(ayah);
    }

    return grouped;
  }

  /// Group results by Juz
  Map<int, List<AyahWithSurah>> groupByJuz() {
    final Map<int, List<AyahWithSurah>> grouped = {};

    for (final ayah in results) {
      grouped.putIfAbsent(ayah.juz, () => []).add(ayah);
    }

    return grouped;
  }

  /// Get statistics about the search results
  SearchStatistics get statistics {
    final surahCounts = <int, int>{};
    final juzCounts = <int, int>{};
    int meccanCount = 0;
    int medinanCount = 0;

    for (final ayah in results) {
      surahCounts[ayah.surah.id] = (surahCounts[ayah.surah.id] ?? 0) + 1;
      juzCounts[ayah.juz] = (juzCounts[ayah.juz] ?? 0) + 1;

      if (ayah.surah.isMeccan) {
        meccanCount++;
      } else {
        medinanCount++;
      }
    }

    return SearchStatistics(
      totalResults: totalResults,
      uniqueSurahs: surahCounts.length,
      uniqueJuz: juzCounts.length,
      meccanResults: meccanCount,
      medinanResults: medinanCount,
      surahDistribution: surahCounts,
      juzDistribution: juzCounts,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResult &&
          runtimeType == other.runtimeType &&
          searchTerm == other.searchTerm &&
          totalResults == other.totalResults &&
          source == other.source;

  @override
  int get hashCode =>
      searchTerm.hashCode ^ totalResults.hashCode ^ source.hashCode;

  @override
  String toString() {
    return 'SearchResult{searchTerm: $searchTerm, totalResults: $totalResults, resultsCount: ${results.length}}';
  }

  /// Creates a copy of this SearchResult with the given fields replaced with new values
  SearchResult copyWith({
    String? searchTerm,
    int? totalResults,
    List<AyahWithSurah>? results,
    String? source,
  }) {
    return SearchResult(
      searchTerm: searchTerm ?? this.searchTerm,
      totalResults: totalResults ?? this.totalResults,
      results: results ?? this.results,
      source: source ?? this.source,
    );
  }
}

/// Statistics about search results.
class SearchStatistics {
  /// Total number of results
  final int totalResults;

  /// Number of unique surahs containing results
  final int uniqueSurahs;

  /// Number of unique Juz containing results
  final int uniqueJuz;

  /// Number of results from Meccan surahs
  final int meccanResults;

  /// Number of results from Medinan surahs
  final int medinanResults;

  /// Distribution of results by surah ID
  final Map<int, int> surahDistribution;

  /// Distribution of results by Juz number
  final Map<int, int> juzDistribution;

  const SearchStatistics({
    required this.totalResults,
    required this.uniqueSurahs,
    required this.uniqueJuz,
    required this.meccanResults,
    required this.medinanResults,
    required this.surahDistribution,
    required this.juzDistribution,
  });

  /// Percentage of results from Meccan surahs
  double get meccanPercentage => totalResults > 0 ? (meccanResults / totalResults) * 100 : 0;

  /// Percentage of results from Medinan surahs
  double get medinanPercentage => totalResults > 0 ? (medinanResults / totalResults) * 100 : 0;

  /// The surah with the most results
  MapEntry<int, int>? get mostFrequentSurah {
    if (surahDistribution.isEmpty) return null;

    return surahDistribution.entries.reduce(
      (curr, next) => curr.value > next.value ? curr : next,
    );
  }

  /// The Juz with the most results
  MapEntry<int, int>? get mostFrequentJuz {
    if (juzDistribution.isEmpty) return null;

    return juzDistribution.entries.reduce(
      (curr, next) => curr.value > next.value ? curr : next,
    );
  }

  @override
  String toString() {
    return 'SearchStatistics{totalResults: $totalResults, uniqueSurahs: $uniqueSurahs, uniqueJuz: $uniqueJuz, meccan: $meccanResults, medinan: $medinanResults}';
  }
}
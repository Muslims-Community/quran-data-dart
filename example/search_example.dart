import 'package:quran_data_dart/quran.dart';

/// Example demonstrating advanced search functionality
///
/// This example shows how to:
/// - Search for specific Arabic text
/// - Filter results by revelation type
/// - Find sajdah ayat
/// - Search within specific surahs
void main() async {
  print('🔍 Quran Search Examples\n');

  // Initialize the service
  await QuranService.initialize();

  // Example 1: Basic text search
  await basicTextSearch();

  // Example 2: Search by surah name
  await searchBySurahName();

  // Example 3: Find all sajdah ayat
  await findSajdahAyat();

  // Example 4: Search statistics
  await searchStatistics();
}

/// Basic Arabic text search
Future<void> basicTextSearch() async {
  print('📖 Basic Text Search');
  print('=' * 50);

  // Search for "الله" (Allah)
  final allahResults = await QuranService.searchText('الله');
  print('Found ${allahResults.totalResults} ayat containing "الله"');

  // Show first 3 results
  for (int i = 0; i < 3 && i < allahResults.results.length; i++) {
    final result = allahResults.results[i];
    print('${i + 1}. ${result.surah.englishName} ${result.id}');
    print('   ${result.text.substring(0, 50)}...\n');
  }

  // Search for "رحمن" (Rahman)
  final rahmanResults = await QuranService.searchText('رحمن');
  print('Found ${rahmanResults.totalResults} ayat containing "رحمن"\n');
}

/// Search for surahs by English name
Future<void> searchBySurahName() async {
  print('🔤 Surah Name Search');
  print('=' * 50);

  final searchResults = await QuranService.searchBySurahName('Light');
  print('Found ${searchResults.totalResults} surahs matching "Light":');

  for (final surah in searchResults.results) {
    print('- ${surah.englishName} (${surah.name}) - ${surah.numberOfAyahs} ayat');
  }
  print('');
}

/// Find all prostration verses
Future<void> findSajdahAyat() async {
  print('🙇 Sajdah (Prostration) Ayat');
  print('=' * 50);

  final sajdahResult = await QuranService.getSajdahAyat();
  print('Total sajdah ayat in Quran: ${sajdahResult.totalSajdahAyat}\n');

  for (int i = 0; i < sajdahResult.sajdahAyat.length; i++) {
    final ayah = sajdahResult.sajdahAyat[i];
    print('${i + 1}. ${ayah.surah.englishName} ${ayah.id}');
    print('   ${ayah.text.substring(0, 60)}...\n');
  }
}

/// Display search and content statistics
Future<void> searchStatistics() async {
  print('📊 Search & Content Statistics');
  print('=' * 50);

  final stats = await QuranService.getSurahStatistics();

  print('Total Surahs: ${stats.totalSurahs}');
  print('Total Ayat: ${stats.totalAyat}');
  print('Meccan Surahs: ${stats.meccanSurahs}');
  print('Medinan Surahs: ${stats.medinanSurahs}');
  print('Average Ayat per Surah: ${stats.averageAyatPerSurah.toStringAsFixed(1)}');
  print('');

  print('Longest Surah: ${stats.longestSurah.englishName} (${stats.longestSurah.numberOfAyahs} ayat)');
  print('Shortest Surah: ${stats.shortestSurah.englishName} (${stats.shortestSurah.numberOfAyahs} ayat)');
  print('');

  // Test search performance
  final stopwatch = Stopwatch()..start();
  await QuranService.searchText('الحمد');
  stopwatch.stop();

  print('Search performance: ${stopwatch.elapsedMilliseconds}ms');
}
# Quran for Dart & Flutter

[![pub package](https://img.shields.io/pub/v/quran_data_dart.svg)](https://pub.dev/packages/quran_data_dart)
[![popularity](https://badges.bar/quran_data_dart/popularity)](https://pub.dev/packages/quran_data_dart/score)
[![likes](https://badges.bar/quran_data_dart/likes)](https://pub.dev/packages/quran_data_dart/score)
[![pub points](https://badges.bar/quran_data_dart/pub%20points)](https://pub.dev/packages/quran_data_dart/score)

**The most comprehensive, lightweight, and offline-first Quran data package for Dart and Flutter applications.**

🚀 **Zero dependencies** • 📱 **Flutter optimized** • 🌐 **Offline-first** • 📖 **Complete Quran** • 🔍 **Full-text search** • 📚 **Tanzil authentic** • 🧩 **Strongly typed** • 🎯 **Tree-shakable**

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🚀 **Zero Dependencies** | No external dependencies, self-contained package |
| 📱 **Flutter Optimized** | Designed specifically for Dart and Flutter applications |
| 🌐 **Offline-First** | Complete Quran text included as assets, no network requests |
| 📖 **Complete Dataset** | All 114 surahs with 6,236 ayat, 30 Juz, 60 Hizb divisions |
| 🔍 **Powerful Search** | Built-in Arabic text search and intelligent surah discovery |
| 📚 **Authentic Source** | Based on official [Tanzil Project](https://tanzil.net) Uthmani minimal text |
| 🧩 **Strongly Typed** | Complete Dart type definitions with comprehensive documentation |
| 🎯 **Tree-Shakable** | Optimized for minimal bundle sizes in Flutter applications |
| 📊 **Rich Analytics** | Comprehensive statistics and insights for educational applications |
| ⚡ **High Performance** | Optimized data structures with efficient lookup algorithms |

## 🚀 Quick Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  quran_data_dart: ^1.7.0
```

Then run:

```bash
flutter pub get
```

## 📖 Quick Start

### Basic Usage

```dart
import 'package:quran_data_dart/quran.dart';

// Initialize the service (call once in your app)
await QuranService.initialize();

// Get Ayat al-Kursi
final ayatAlKursi = await QuranService.getAyah(2, 255);
print(ayatAlKursi.text);

// Get complete Al-Fatiha
final alFatiha = await QuranService.getSurah(1);
print('${alFatiha.englishName}: ${alFatiha.numberOfAyahs} ayat');

// Search for "Allah"
final results = await QuranService.searchText('الله');
print('Found ${results.totalResults} ayat containing "الله"');
```

### Enhanced Functions

```dart
import 'package:quran_data_dart/quran.dart';

// Daily Juz reading
final juz1 = await QuranService.getJuz(1);
print('Juz 1: ${juz1.totalAyat} ayat');

// Range reading for study
final range = await QuranService.getAyahRange(18, 1, 10); // Al-Kahf 1-10
print('Reading ${range.range.count} ayat from ${range.surah.englishName}');

// Find surahs easily
final kahf = await QuranService.searchBySurahName('Cave'); // Finds Al-Kahf
print('Found: ${kahf.results.first.englishName}');

// Get comprehensive statistics
final stats = await QuranService.getSurahStatistics();
print('📊 ${stats.totalSurahs} surahs, ${stats.totalAyat} ayat');
```

## 🎯 Complete API Reference

### Core Functions

| Function | Purpose | Returns |
|----------|---------|---------|
| `QuranService.getAyah(surahId, ayahId)` | Get specific ayah with metadata | `Future<AyahWithSurah>` |
| `QuranService.getSurah(surahId)` | Get complete surah with all ayat | `Future<Surah>` |
| `QuranService.getQuranData()` | Get complete Quran dataset | `Future<QuranData>` |
| `QuranService.searchText(searchTerm)` | Search Arabic text across Quran | `Future<SearchResult>` |
| `QuranService.getRandomAyah()` | Get random ayah for inspiration | `Future<AyahWithSurah>` |
| `QuranService.getSajdahAyat()` | Get all prostration verses | `Future<SajdahResult>` |

### Enhanced Functions

| Function | Purpose | Returns | Use Case |
|----------|---------|---------|----------|
| `QuranService.getAyahRange(surahId, start, end)` | Get consecutive ayat range | `Future<AyahRange>` | Reading apps, study sessions |
| `QuranService.getJuz(juzNumber)` | Get complete Juz (1-30) | `Future<JuzResult>` | Daily reading, progress tracking |
| `QuranService.getHizb(hizbNumber)` | Get complete Hizb (1-60) | `Future<HizbResult>` | Flexible reading portions |
| `QuranService.searchBySurahName(name)` | Find surahs by name | `Future<SurahSearchResult>` | Surah discovery, navigation |
| `QuranService.getSurahStatistics()` | Get comprehensive stats | `Future<SurahStatistics>` | Analytics, educational insights |

## 🎨 Flutter Widget Examples

### Daily Reading Widget

```dart
import 'package:flutter/material.dart';
import 'package:quran_data_dart/quran.dart';

class DailyReadingWidget extends StatefulWidget {
  @override
  _DailyReadingWidgetState createState() => _DailyReadingWidgetState();
}

class _DailyReadingWidgetState extends State<DailyReadingWidget> {
  JuzResult? dailyJuz;
  AyahWithSurah? inspirationalAyah;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDailyReading();
  }

  Future<void> loadDailyReading() async {
    await QuranService.initialize();

    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;
    final juzNumber = ((dayOfYear - 1) % 30) + 1;

    final juz = await QuranService.getJuz(juzNumber);
    final randomAyah = await QuranService.getRandomAyah();

    setState(() {
      dailyJuz = juz;
      inspirationalAyah = randomAyah;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily Reading Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📖 Today\'s Reading - Juz ${dailyJuz!.juz}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dailyJuz!.totalAyat} ayat • ~${(dailyJuz!.totalAyat / 2).round()} minutes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  // Show first 3 ayat as preview
                  ...dailyJuz!.ayat.take(3).map((ayah) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ayah.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Arabic',
                            height: 1.8,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ayah.surah.englishName} ${ayah.id}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  )),
                  if (dailyJuz!.ayat.length > 3)
                    Text(
                      '... and ${dailyJuz!.ayat.length - 3} more ayat',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Inspirational Ayah Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Inspiration',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          inspirationalAyah!.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Arabic',
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${inspirationalAyah!.surah.englishName} ${inspirationalAyah!.id}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Search Widget

```dart
import 'package:flutter/material.dart';
import 'package:quran_data_dart/quran.dart';

class QuranSearchWidget extends StatefulWidget {
  @override
  _QuranSearchWidgetState createState() => _QuranSearchWidgetState();
}

class _QuranSearchWidgetState extends State<QuranSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  SearchResult? searchResults;
  SurahSearchResult? surahResults;
  bool isLoading = false;
  String? searchType;

  @override
  void initState() {
    super.initState();
    QuranService.initialize();
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      searchResults = null;
      surahResults = null;
      searchType = null;
    });

    try {
      // Try surah search first
      final surahSearchResults = await QuranService.searchBySurahName(query);
      if (surahSearchResults.totalResults > 0) {
        setState(() {
          surahResults = surahSearchResults;
          searchType = 'surah';
          isLoading = false;
        });
        return;
      }

      // Then try text search
      final textSearchResults = await QuranService.searchText(query);
      setState(() {
        searchResults = textSearchResults;
        searchType = 'text';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Input
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Quran...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          searchResults = null;
                          surahResults = null;
                          searchType = null;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: performSearch,
            onChanged: (value) {
              setState(() {}); // Update UI for clear button
            },
          ),
        ),

        // Loading Indicator
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),

        // Search Results
        if (searchType == 'surah' && surahResults != null)
          Expanded(
            child: ListView.builder(
              itemCount: surahResults!.results.length,
              itemBuilder: (context, index) {
                final surah = surahResults!.results[index];
                return ListTile(
                  title: Text('${surah.englishName} (${surah.name})'),
                  subtitle: Text(
                    '${surah.numberOfAyahs} ayat • ${surah.revelationType}',
                  ),
                  leading: CircleAvatar(
                    child: Text('${surah.id}'),
                  ),
                  onTap: () {
                    // Navigate to surah details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailsScreen(surah: surah),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        if (searchType == 'text' && searchResults != null)
          Expanded(
            child: Column(
              children: [
                // Results Summary
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Found ${searchResults!.totalResults} ayat containing "${searchResults!.searchTerm}"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                // Results List
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults!.results.take(50).length,
                    itemBuilder: (context, index) {
                      final ayah = searchResults!.results[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ayah.text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Arabic',
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${ayah.surah.englishName} ${ayah.id}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Text(
                                    'Juz ${ayah.juz} • Hizb ${ayah.hizb}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

        // No Results
        if (searchType != null &&
            ((searchType == 'text' && (searchResults?.totalResults ?? 0) == 0) ||
             (searchType == 'surah' && (surahResults?.totalResults ?? 0) == 0)))
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No results found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try searching for "الله", "رب", or surah names like "Fatiha"',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Placeholder for surah details screen
class SurahDetailsScreen extends StatelessWidget {
  final Surah surah;

  const SurahDetailsScreen({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surah.englishName),
      ),
      body: const Center(
        child: Text('Surah details would be implemented here'),
      ),
    );
  }
}
```

### Statistics Dashboard Widget

```dart
import 'package:flutter/material.dart';
import 'package:quran_data_dart/quran.dart';

class QuranStatisticsWidget extends StatefulWidget {
  @override
  _QuranStatisticsWidgetState createState() => _QuranStatisticsWidgetState();
}

class _QuranStatisticsWidgetState extends State<QuranStatisticsWidget> {
  SurahStatistics? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    await QuranService.initialize();
    final statistics = await QuranService.getSurahStatistics();

    setState(() {
      stats = statistics;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Quran Overview',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Basic Statistics Grid
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                'Total Surahs',
                '${stats!.totalSurahs}',
                Icons.book,
                Colors.blue,
              ),
              _buildStatCard(
                'Total Ayat',
                '${stats!.totalAyat}',
                Icons.format_list_numbered,
                Colors.green,
              ),
              _buildStatCard(
                'Meccan Surahs',
                '${stats!.meccanSurahs}',
                Icons.location_on,
                Colors.orange,
              ),
              _buildStatCard(
                'Medinan Surahs',
                '${stats!.medinanSurahs}',
                Icons.location_city,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Extremes Section
          Text(
            '📏 Length Extremes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildExtremeTile(
                    'Longest Surah',
                    stats!.longestSurah.englishName,
                    '${stats!.longestSurah.numberOfAyahs} ayat',
                    Icons.expand_more,
                    Colors.red,
                  ),
                  const Divider(),
                  _buildExtremeTile(
                    'Shortest Surah',
                    stats!.shortestSurah.englishName,
                    '${stats!.shortestSurah.numberOfAyahs} ayat',
                    Icons.expand_less,
                    Colors.teal,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Reading Time Estimation
          Text(
            '⏰ Reading Estimates',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildReadingTimeTile(
                    'Complete Quran',
                    '~${(stats!.totalAyat / 2 / 60).round()} hours',
                    '(at 2 ayat/minute)',
                  ),
                  const Divider(),
                  _buildReadingTimeTile(
                    'Daily Juz Plan',
                    '~${(stats!.totalAyat / 30 / 2).round()} minutes/day',
                    '(30-day completion)',
                  ),
                  const Divider(),
                  _buildReadingTimeTile(
                    'Average Surah',
                    '~${(stats!.averageAyatPerSurah / 2).round()} minutes',
                    '(${stats!.averageAyatPerSurah.round()} ayat)',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Revelation Analysis
          Text(
            '🏛️ Revelation Analysis',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildRevelationColumn(
                          'Meccan',
                          '${((stats!.meccanSurahs / stats!.totalSurahs) * 100).round()}%',
                          '${stats!.revelationAnalysis.meccanCharacteristics.averageLength.round()} avg ayat',
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRevelationColumn(
                          'Medinan',
                          '${((stats!.medinanSurahs / stats!.totalSurahs) * 100).round()}%',
                          '${stats!.revelationAnalysis.medinanCharacteristics.averageLength.round()} avg ayat',
                          Colors.purple,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtremeTile(String label, String name, String detail, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      subtitle: Text(name),
      trailing: Text(detail),
    );
  }

  Widget _buildReadingTimeTile(String title, String time, String detail) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(title),
      subtitle: Text(detail),
      trailing: Text(
        time,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRevelationColumn(String title, String percentage, String avgLength, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          avgLength,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
```

## 🎨 Advanced Usage Patterns

### Reading Progress Manager

```dart
import 'package:quran_data_dart/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranReadingProgress {
  static const String _completedJuzKey = 'completed_juz';
  static const String _currentJuzKey = 'current_juz';
  static const String _startDateKey = 'start_date';

  late SharedPreferences _prefs;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await QuranService.initialize();
  }

  List<int> getCompletedJuz() {
    final completedJuzJson = _prefs.getStringList(_completedJuzKey) ?? [];
    return completedJuzJson.map((e) => int.parse(e)).toList();
  }

  int getCurrentJuz() {
    return _prefs.getInt(_currentJuzKey) ?? 1;
  }

  DateTime? getStartDate() {
    final startDateString = _prefs.getString(_startDateKey);
    return startDateString != null ? DateTime.parse(startDateString) : null;
  }

  Future<void> markJuzCompleted(int juzNumber) async {
    final completed = getCompletedJuz();
    if (!completed.contains(juzNumber)) {
      completed.add(juzNumber);
      await _prefs.setStringList(_completedJuzKey, completed.map((e) => e.toString()).toList());

      // Update current Juz
      final nextJuz = (completed.length < 30) ? completed.length + 1 : 30;
      await _prefs.setInt(_currentJuzKey, nextJuz);
    }
  }

  Future<void> setStartDate(DateTime date) async {
    await _prefs.setString(_startDateKey, date.toIso8601String());
  }

  Future<ProgressSummary> getProgressSummary() async {
    final stats = await QuranService.getSurahStatistics();
    final completed = getCompletedJuz();
    final startDate = getStartDate();

    int completedAyat = 0;
    for (final juzNumber in completed) {
      final juz = await QuranService.getJuz(juzNumber);
      completedAyat += juz.totalAyat;
    }

    final percentComplete = (completedAyat / stats.totalAyat * 100);
    final daysActive = startDate != null
        ? DateTime.now().difference(startDate).inDays
        : 0;

    return ProgressSummary(
      completedJuz: completed.length,
      totalJuz: 30,
      completedAyat: completedAyat,
      totalAyat: stats.totalAyat,
      percentComplete: percentComplete,
      daysActive: daysActive,
      averageJuzPerDay: daysActive > 0 ? completed.length / daysActive : 0,
    );
  }

  Future<JuzResult> getNextReading() async {
    final currentJuz = getCurrentJuz();
    return await QuranService.getJuz(currentJuz);
  }
}

class ProgressSummary {
  final int completedJuz;
  final int totalJuz;
  final int completedAyat;
  final int totalAyat;
  final double percentComplete;
  final int daysActive;
  final double averageJuzPerDay;

  ProgressSummary({
    required this.completedJuz,
    required this.totalJuz,
    required this.completedAyat,
    required this.totalAyat,
    required this.percentComplete,
    required this.daysActive,
    required this.averageJuzPerDay,
  });
}
```

## 🌍 Platform Support

This package supports all platforms where Dart and Flutter are available:

- ✅ **Android** - Full support with optimized performance
- ✅ **iOS** - Full support with native performance
- ✅ **Web** - Full support for Progressive Web Apps
- ✅ **macOS** - Full support for desktop applications
- ✅ **Windows** - Full support for desktop applications
- ✅ **Linux** - Full support for desktop applications

## 📊 Package Statistics

| Metric | Value |
|--------|-------|
| **Bundle Size** | ~2.1 MB (includes complete Quran data) |
| **Dependencies** | 0 (zero external dependencies) |
| **Functions** | 11 total (6 core + 5 enhanced) |
| **Data Points** | 6,236 ayat across 114 surahs |
| **Performance** | Optimized for mobile and desktop |

## 🛠️ Contributing

We welcome contributions from the Muslim developer community and beyond!

### Development Setup

```bash
git clone https://github.com/Muslims-Community/quran-data-dart.git
cd quran-data-dart
flutter pub get
flutter test
```

### Ways to Contribute

- 🐛 **Report Bugs** - Help us improve quality
- 💡 **Request Features** - Suggest new functionality
- 📖 **Improve Documentation** - Help others learn
- 🧪 **Add Tests** - Increase reliability
- 🌍 **Add Translations** - Make it globally accessible

## 📜 License & Attribution

### Package License
- **MIT License** - Free for commercial and non-commercial use

### Quran Text License
- **Source**: [Tanzil Project](https://tanzil.net) - Uthmani Minimal v1.1
- **License**: Creative Commons Attribution 3.0
- **Requirements**: Attribution to Tanzil Project must be maintained

## 🚀 Roadmap

### **v1.2.0** (Coming Soon)
- 🧭 Navigation functions (`getNextAyah`, `getPreviousAyah`)
- 🔍 Advanced search with filters and relevance scoring
- 📖 Reading plan generators
- 📱 Flutter-specific optimizations

### **v1.3.0** (Planned)
- 🏷️ Thematic organization and tagging
- 📊 Word frequency analysis
- 📤 Export functionality (JSON, CSV)
- 🔗 Cross-reference linking

### **v2.0.0** (Future Vision)
- 🌍 Translation integration
- 🎵 Audio data support
- 🤖 AI-powered features
- ☁️ Optional cloud synchronization

---

## 💝 Made with Love by Muslims Community

This package is created and maintained by developers who love both code and the Quran. Our mission is to make Quranic knowledge easily accessible through modern technology while maintaining the highest standards of authenticity and respect.

### Islamic Values in Development
- ✅ **Authenticity** - Using verified Tanzil Project text
- ✅ **Accessibility** - Making Quran available to all developers
- ✅ **Quality** - Following best practices in software development
- ✅ **Community** - Encouraging collaboration and knowledge sharing
- ✅ **Respect** - Maintaining the sanctity and accuracy of Quranic text

---

*"And We have certainly made the Qur'an easy for remembrance, so is there any who will remember?"* - **Al-Qamar 54:17**

![GitHub stars](https://img.shields.io/github/stars/Muslims-Community/quran-data-dart?style=social)
![GitHub forks](https://img.shields.io/github/forks/Muslims-Community/quran-data-dart?style=social)
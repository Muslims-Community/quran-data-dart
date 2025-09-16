import 'package:flutter/material.dart';
import 'package:quran/quran.dart';

void main() {
  runApp(QuranExampleApp());
}

class QuranExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Package Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: QuranHomePage(),
    );
  }
}

class QuranHomePage extends StatefulWidget {
  @override
  _QuranHomePageState createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  int _selectedIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeQuran();
  }

  Future<void> _initializeQuran() async {
    await QuranService.initialize();
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading Quran data...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Package Example'),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DailyReadingTab(),
          SearchTab(),
          StatisticsTab(),
          ExamplesTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Daily Reading',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Examples',
          ),
        ],
      ),
    );
  }
}

class DailyReadingTab extends StatefulWidget {
  @override
  _DailyReadingTabState createState() => _DailyReadingTabState();
}

class _DailyReadingTabState extends State<DailyReadingTab> {
  JuzResult? dailyJuz;
  AyahWithSurah? inspirationalAyah;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDailyReading();
  }

  Future<void> loadDailyReading() async {
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
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📖 Today\'s Reading - Juz ${dailyJuz!.juz}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${dailyJuz!.totalAyat} ayat • ~${dailyJuz!.estimatedReadingMinutes.round()} minutes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Surahs in this Juz: ${dailyJuz!.surahsInJuz.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (dailyJuz!.hasSajdah)
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '🕌 Contains ${dailyJuz!.sajdahAyat.length} Sajdah verse(s)',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Daily Inspiration',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          inspirationalAyah!.text,
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.8,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                        ),
                        SizedBox(height: 12),
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

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  SearchResult? searchResults;
  SurahSearchResult? surahResults;
  bool isLoading = false;
  String? searchType;

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      isLoading = true;
      searchResults = null;
      surahResults = null;
      searchType = null;
    });

    try {
      final surahSearchResults = await QuranService.searchBySurahName(query);
      if (surahSearchResults.totalResults > 0) {
        setState(() {
          surahResults = surahSearchResults;
          searchType = 'surah';
          isLoading = false;
        });
        return;
      }

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
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Quran...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: performSearch,
          ),
        ),
        if (isLoading)
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
        if (searchType == 'text' && searchResults != null)
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Found ${searchResults!.totalResults} ayat containing "${searchResults!.searchTerm}"',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults!.results.take(50).length,
                    itemBuilder: (context, index) {
                      final ayah = searchResults!.results[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ayah.text,
                                style: TextStyle(fontSize: 16, height: 1.6),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${ayah.surah.englishName} ${ayah.id} • Juz ${ayah.juz}',
                                style: Theme.of(context).textTheme.bodySmall,
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
        if (searchType == 'surah' && surahResults != null)
          Expanded(
            child: ListView.builder(
              itemCount: surahResults!.results.length,
              itemBuilder: (context, index) {
                final surah = surahResults!.results[index];
                return ListTile(
                  title: Text('${surah.englishName} (${surah.name})'),
                  subtitle: Text('${surah.numberOfAyahs} ayat • ${surah.revelationType}'),
                  leading: CircleAvatar(child: Text('${surah.id}')),
                );
              },
            ),
          ),
      ],
    );
  }
}

class StatisticsTab extends StatefulWidget {
  @override
  _StatisticsTabState createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {
  SurahStatistics? stats;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    final statistics = await QuranService.getSurahStatistics();
    setState(() {
      stats = statistics;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Quran Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard('Total Surahs', '${stats!.totalSurahs}', Icons.book, Colors.blue),
              _buildStatCard('Total Ayat', '${stats!.totalAyat}', Icons.format_list_numbered, Colors.green),
              _buildStatCard('Meccan Surahs', '${stats!.meccanSurahs}', Icons.location_on, Colors.orange),
              _buildStatCard('Medinan Surahs', '${stats!.medinanSurahs}', Icons.location_city, Colors.purple),
            ],
          ),
          SizedBox(height: 24),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📏 Length Extremes', style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 12),
                  ListTile(
                    leading: Icon(Icons.expand_more, color: Colors.red),
                    title: Text('Longest Surah'),
                    subtitle: Text(stats!.longestSurah.englishName),
                    trailing: Text('${stats!.longestSurah.numberOfAyahs} ayat'),
                  ),
                  ListTile(
                    leading: Icon(Icons.expand_less, color: Colors.teal),
                    title: Text('Shortest Surah'),
                    subtitle: Text(stats!.shortestSurah.englishName),
                    trailing: Text('${stats!.shortestSurah.numberOfAyahs} ayat'),
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ExamplesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💻 Code Examples',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          _buildExampleCard(
            'Get Random Ayah',
            'final ayah = await QuranService.getRandomAyah();\nprint(ayah.text);',
            context,
          ),
          _buildExampleCard(
            'Search Text',
            'final results = await QuranService.searchText(\'الله\');\nprint(\'Found \${results.totalResults} ayat\');',
            context,
          ),
          _buildExampleCard(
            'Get Juz',
            'final juz = await QuranService.getJuz(1);\nprint(\'Juz 1: \${juz.totalAyat} ayat\');',
            context,
          ),
          _buildExampleCard(
            'Get Ayah Range',
            'final range = await QuranService.getAyahRange(1, 1, 7);\nprint(\'Al-Fatiha: \${range.range.count} ayat\');',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String title, String code, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
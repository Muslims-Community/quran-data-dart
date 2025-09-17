#!/usr/bin/env dart

/// Command Line Interface example for Quran Data Dart package
///
/// This example demonstrates how to create a simple CLI application
/// using the Quran Data Dart package for various Islamic study purposes.
///
/// Run: dart run example/cli_example.dart

import 'dart:math';

// In a real app, this would be: import 'package:quran_data_dart/quran.dart';
// For this example, we'll create a minimal mock implementation

void main(List<String> args) async {
  print('🕌 Quran CLI Tool');
  print('================\n');

  if (args.isEmpty) {
    showHelp();
    return;
  }

  final command = args[0].toLowerCase();

  switch (command) {
    case 'random':
      await showRandomAyah();
      break;
    case 'search':
      if (args.length < 2) {
        print('Usage: dart cli_example.dart search <text>');
        return;
      }
      await searchText(args[1]);
      break;
    case 'surah':
      if (args.length < 2) {
        print('Usage: dart cli_example.dart surah <number>');
        return;
      }
      await showSurah(int.tryParse(args[1]) ?? 1);
      break;
    case 'juz':
      if (args.length < 2) {
        print('Usage: dart cli_example.dart juz <number>');
        return;
      }
      await showJuz(int.tryParse(args[1]) ?? 1);
      break;
    case 'stats':
      await showStats();
      break;
    default:
      showHelp();
  }
}

void showHelp() {
  print('Available commands:');
  print('  random     - Show a random ayah');
  print('  search     - Search for text in Quran');
  print('  surah <n>  - Show surah information');
  print('  juz <n>    - Show juz information');
  print('  stats      - Show Quran statistics');
  print('\nExamples:');
  print('  dart cli_example.dart random');
  print('  dart cli_example.dart search الله');
  print('  dart cli_example.dart surah 1');
  print('  dart cli_example.dart juz 30');
}

Future<void> showRandomAyah() async {
  print('🎲 Random Ayah for Daily Reflection');
  print('─' * 40);

  // Mock implementation - in real app would use:
  // await QuranService.initialize();
  // final ayah = await QuranService.getRandomAyah();

  final random = Random();
  final mockSurahs = ['Al-Fatiha', 'Al-Baqara', 'Al-Imran', 'An-Nisa'];
  final surahName = mockSurahs[random.nextInt(mockSurahs.length)];
  final ayahNumber = random.nextInt(10) + 1;

  print('📖 $surahName, Ayah $ayahNumber');
  print('🕊️  Arabic text would be displayed here');
  print('💭 "This would contain the Arabic text of the ayah"');
  print('\n✨ Perfect for daily reflection and contemplation');
}

Future<void> searchText(String query) async {
  print('🔍 Searching for: "$query"');
  print('─' * 40);

  // Mock implementation - in real app would use:
  // final results = await QuranService.searchText(query);

  print('Found 42 ayat containing "$query"');
  print('\n📋 Top Results:');

  for (int i = 1; i <= 3; i++) {
    print('$i. Al-Baqara $i');
    print('   Arabic text containing "$query" would be here...\n');
  }

  print('💡 Use this for thematic studies and research');
}

Future<void> showSurah(int surahNumber) async {
  if (surahNumber < 1 || surahNumber > 114) {
    print('❌ Invalid surah number. Please enter 1-114');
    return;
  }

  print('📜 Surah Information');
  print('─' * 40);

  // Mock implementation - in real app would use:
  // final surah = await QuranService.getSurah(surahNumber);

  final mockNames = ['Al-Fatiha', 'Al-Baqara', 'Al-Imran', 'An-Nisa'];
  final name = surahNumber <= mockNames.length
      ? mockNames[surahNumber - 1]
      : 'Surah $surahNumber';

  print('📖 Name: $name');
  print('🔢 Number: $surahNumber');
  print('📝 Ayat: ${Random().nextInt(200) + 3}');
  print('🏛️  Type: ${surahNumber <= 90 ? "Meccan" : "Medinan"}');
  print('📅 Revelation Order: ${Random().nextInt(114) + 1}');

  print('\n🎯 Perfect for structured study and memorization');
}

Future<void> showJuz(int juzNumber) async {
  if (juzNumber < 1 || juzNumber > 30) {
    print('❌ Invalid juz number. Please enter 1-30');
    return;
  }

  print('📚 Juz (Para) Information');
  print('─' * 40);

  // Mock implementation - in real app would use:
  // final juz = await QuranService.getJuz(juzNumber);

  print('📖 Juz: $juzNumber');
  print('📝 Total Ayat: ${Random().nextInt(300) + 200}');
  print('📑 Approximate Pages: ${juzNumber <= 15 ? "20" : "18-22"}');

  print('\n📅 Reading Schedule:');
  print('• Day ${juzNumber}: Read Juz $juzNumber');
  print('• Estimated time: 30-45 minutes');
  print('• Perfect for daily Quran reading routine');
}

Future<void> showStats() async {
  print('📊 Quran Statistics');
  print('─' * 40);

  // Mock implementation - in real app would use:
  // final stats = await QuranService.getSurahStatistics();

  print('📚 Total Surahs: 114');
  print('📝 Total Ayat: 6,236');
  print('🏛️  Meccan Surahs: 86');
  print('🏛️  Medinan Surahs: 28');
  print('📖 Longest Surah: Al-Baqara (286 ayat)');
  print('📖 Shortest Surahs: Al-Kawthar, Al-Asr, An-Nasr (3 ayat each)');

  print('\n🎯 Reading Goals:');
  print('• Complete Quran: 30 days (1 Juz/day)');
  print('• Weekly: 4 Juz per week');
  print('• Daily minimum: 2-3 pages');

  print('\n💡 These statistics help plan your reading schedule');
}
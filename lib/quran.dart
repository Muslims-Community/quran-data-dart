/// A comprehensive, lightweight, and offline-first Quran data package for Dart and Flutter applications.
///
/// This library provides access to the complete Quran text with authentic Arabic text from the Tanzil Project,
/// along with powerful search capabilities, Islamic reading divisions (Juz/Hizb), and comprehensive statistics.
///
/// Features:
/// - Complete Quran text (114 surahs, 6,236 ayat)
/// - Zero dependencies, offline-first
/// - Juz and Hizb reading divisions
/// - Full-text Arabic search
/// - Comprehensive statistics and analytics
/// - Flutter and Dart compatible
///
/// Example usage:
/// ```dart
/// import 'package:quran_data_dart/quran.dart';
///
/// // Initialize the service first
/// await QuranService.initialize();
///
/// // Get specific ayah
/// final ayah = await QuranService.getAyah(2, 255); // Ayat al-Kursi
/// print(ayah.text);
///
/// // Get complete surah
/// final surah = await QuranService.getSurah(1); // Al-Fatiha
/// print('${surah.englishName}: ${surah.numberOfAyahs} ayat');
///
/// // Search for text
/// final results = await QuranService.searchText('الله');
/// print('Found ${results.totalResults} ayat containing "الله"');
///
/// // Get daily Juz reading
/// final juz = await QuranService.getJuz(1);
/// print('Juz 1: ${juz.totalAyat} ayat');
///
/// // Get random ayah for daily reflection
/// final randomAyah = await QuranService.getRandomAyah();
/// print('Daily reflection: ${randomAyah.surah.englishName} ${randomAyah.id}');
/// ```
library quran;

// Core exports
export 'src/quran_service.dart';
export 'src/quran_data_loader.dart';

// Model exports
export 'models/ayah.dart';
export 'models/surah.dart';
export 'models/juz_result.dart';
export 'models/hizb_result.dart';
export 'models/search_result.dart';
export 'models/surah_search_result.dart';
export 'models/ayah_range.dart';
export 'models/surah_statistics.dart';
export 'models/sajdah_result.dart';
export 'models/quran_data.dart';

// Utility exports
export 'src/utils/constants.dart';
export 'src/utils/validators.dart';
export 'src/utils/extensions.dart';

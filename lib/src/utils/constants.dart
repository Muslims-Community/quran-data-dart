/// Constants used throughout the Quran package.
class QuranConstants {
  /// Total number of surahs in the Quran
  static const int totalSurahs = 114;

  /// Total number of ayat in the Quran
  static const int totalAyat = 6236;

  /// Total number of Juz (Para) in the Quran
  static const int totalJuz = 30;

  /// Total number of Hizb in the Quran
  static const int totalHizb = 60;

  /// Number of Hizb per Juz
  static const int hizbPerJuz = 2;

  /// Total number of sajdah ayat in the Quran
  static const int totalSajdahAyat = 15;

  /// Source attribution for Quran text
  static const String defaultSource = 'Tanzil Project - https://tanzil.net';

  /// Default package version
  static const String packageVersion = '1.1.0';

  /// Revelation types
  static const String meccanRevelationType = 'Meccan';
  static const String medinanRevelationType = 'Medinan';

  /// Path to Quran data asset
  static const String quranDataAssetPath = 'assets/quran.json';

  /// Average reading speed (ayat per minute)
  static const double averageReadingSpeed = 2.0;

  /// Character encoding multiplier for size calculation
  static const int utf16CharacterBytes = 2;

  /// Minimum ayat count in any surah
  static const int minAyatInSurah = 3;

  /// Maximum ayat count in any surah
  static const int maxAyatInSurah = 286;

  /// Surah with minimum ayat (Al-Asr)
  static const int shortestSurahId = 103;

  /// Surah with maximum ayat (Al-Baqarah)
  static const int longestSurahId = 2;

  /// Days in a standard Quran reading plan
  static const int standardReadingPlanDays = 30;

  /// Maximum search results to return by default
  static const int defaultMaxSearchResults = 100;

  /// Minimum search term length
  static const int minSearchTermLength = 1;

  /// Maximum search term length
  static const int maxSearchTermLength = 100;

  /// Cache expiration time in hours
  static const int cacheExpirationHours = 24;

  /// Default pagination limit
  static const int defaultPaginationLimit = 20;

  /// Maximum pagination limit
  static const int maxPaginationLimit = 1000;
}

/// Regex patterns for validation.
class QuranRegexPatterns {
  /// Arabic character range
  static const String arabicCharacters =
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]';

  /// Basic Arabic text validation
  static RegExp arabicTextRegex = RegExp(arabicCharacters);

  /// Email validation
  static RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  /// URL validation
  static RegExp urlRegex = RegExp(
      r'^https?:\/\/([\w\-]+(\.[\w\-]+)+)([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$');

  /// Version number validation (semantic versioning)
  static RegExp versionRegex =
      RegExp(r'^\d+\.\d+\.\d+(-[a-zA-Z0-9\-]+)?(\+[a-zA-Z0-9\-]+)?$');
}

/// Quran-specific numerical constants.
class QuranNumbers {
  /// Surat al-Fatiha
  static const int alFatihaId = 1;

  /// Surat al-Baqarah
  static const int alBaqarahId = 2;

  /// Surat Al-Imran
  static const int alImranId = 3;

  /// Surat an-Nas (last surah)
  static const int anNasId = 114;

  /// Ayat al-Kursi (Al-Baqarah 255)
  static const int ayatAlKursiSurahId = 2;
  static const int ayatAlKursiAyahId = 255;

  /// First revealed ayah (Al-Alaq 1)
  static const int firstRevelationSurahId = 96;
  static const int firstRevelationAyahId = 1;

  /// Last revealed ayah (Al-Baqarah 281)
  static const int lastRevelationSurahId = 2;
  static const int lastRevelationAyahId = 281;

  /// Number of ayat in Al-Fatiha
  static const int alFatihaAyatCount = 7;

  /// Number of ayat in Al-Baqarah (longest surah)
  static const int alBaqarahAyatCount = 286;

  /// Number of ayat in Al-Asr (shortest surah)
  static const int alAsrAyatCount = 3;
}

/// Error messages used throughout the package.
class QuranErrorMessages {
  /// Invalid surah ID error
  static String invalidSurahId(int surahId) =>
      'Surah ID must be between 1 and ${QuranConstants.totalSurahs}, got: $surahId';

  /// Invalid ayah ID error
  static String invalidAyahId(int ayahId, int maxAyat) =>
      'Ayah ID must be between 1 and $maxAyat, got: $ayahId';

  /// Invalid Juz number error
  static String invalidJuzNumber(int juzNumber) =>
      'Juz number must be between 1 and ${QuranConstants.totalJuz}, got: $juzNumber';

  /// Invalid Hizb number error
  static String invalidHizbNumber(int hizbNumber) =>
      'Hizb number must be between 1 and ${QuranConstants.totalHizb}, got: $hizbNumber';

  /// Invalid ayah range error
  static String invalidAyahRange(int start, int end) =>
      'Start ayah ($start) cannot be greater than end ayah ($end)';

  /// Empty search term error
  static const String emptySearchTerm = 'Search term cannot be empty';

  /// Search term too short error
  static String searchTermTooShort(int minLength) =>
      'Search term must be at least $minLength character(s) long';

  /// Search term too long error
  static String searchTermTooLong(int maxLength) =>
      'Search term cannot exceed $maxLength characters';

  /// Data not initialized error
  static const String dataNotInitialized =
      'QuranService not initialized. Call QuranService.initialize() first.';

  /// Invalid revelation type error
  static String invalidRevelationType(String revelationType) =>
      'Revelation type must be "${QuranConstants.meccanRevelationType}" or "${QuranConstants.medinanRevelationType}", got: $revelationType';

  /// Invalid page number error
  static String invalidPageNumber(int page) =>
      'Page number must be at least 1, got: $page';

  /// Invalid limit error
  static String invalidLimit(int limit, int maxLimit) =>
      'Limit must be between 1 and $maxLimit, got: $limit';

  /// File not found error
  static String fileNotFound(String filePath) => 'File not found: $filePath';

  /// Invalid JSON structure error
  static String invalidJsonStructure(String details) =>
      'Invalid JSON structure: $details';

  /// Network error
  static String networkError(String details) => 'Network error: $details';

  /// Cache error
  static String cacheError(String details) => 'Cache error: $details';

  /// Permission error
  static String permissionError(String details) => 'Permission error: $details';
}

/// Success messages and informational constants.
class QuranMessages {
  /// Data loaded successfully
  static const String dataLoadedSuccessfully = 'Quran data loaded successfully';

  /// Cache cleared successfully
  static const String cacheClearedSuccessfully = 'Cache cleared successfully';

  /// Search completed successfully
  static String searchCompleted(int resultCount) =>
      'Search completed successfully. Found $resultCount result(s).';

  /// Statistics generated successfully
  static const String statisticsGenerated = 'Statistics generated successfully';

  /// Data validated successfully
  static const String dataValidated = 'Quran data validated successfully';

  /// Export completed successfully
  static String exportCompleted(String format) =>
      'Export to $format completed successfully';

  /// Import completed successfully
  static String importCompleted(String source) =>
      'Import from $source completed successfully';
}

/// Configuration defaults.
class QuranDefaults {
  /// Default language code
  static const String defaultLanguage = 'ar';

  /// Default text direction
  static const String defaultTextDirection = 'rtl';

  /// Default font family for Arabic text
  static const String defaultArabicFont = 'Amiri';

  /// Default font size for Arabic text
  static const double defaultArabicFontSize = 18.0;

  /// Default line height for Arabic text
  static const double defaultArabicLineHeight = 1.8;

  /// Default color for Arabic text
  static const String defaultArabicTextColor = '#000000';

  /// Default background color
  static const String defaultBackgroundColor = '#FFFFFF';

  /// Default highlight color for search results
  static const String defaultHighlightColor = '#FFFF00';

  /// Default animation duration in milliseconds
  static const int defaultAnimationDuration = 300;

  /// Default debounce delay for search in milliseconds
  static const int defaultSearchDebounceDelay = 300;

  /// Default cache size in MB
  static const int defaultCacheSizeMB = 10;

  /// Default timeout for operations in seconds
  static const int defaultTimeoutSeconds = 30;
}

/// Feature flags for optional functionality.
class QuranFeatureFlags {
  /// Enable caching
  static const bool enableCaching = true;

  /// Enable analytics
  static const bool enableAnalytics = false;

  /// Enable offline mode
  static const bool enableOfflineMode = true;

  /// Enable search highlighting
  static const bool enableSearchHighlighting = true;

  /// Enable reading progress tracking
  static const bool enableProgressTracking = true;

  /// Enable bookmark functionality
  static const bool enableBookmarks = true;

  /// Enable audio support
  static const bool enableAudioSupport = false;

  /// Enable translation support
  static const bool enableTranslationSupport = false;

  /// Enable advanced search
  static const bool enableAdvancedSearch = true;

  /// Enable export functionality
  static const bool enableExport = true;
}

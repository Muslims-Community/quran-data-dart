/// Validation utilities for Quran data parameters.
class QuranValidators {
  /// Validate surah ID (1-114)
  static void validateSurahId(int surahId) {
    if (surahId < 1 || surahId > 114) {
      throw ArgumentError('Surah ID must be between 1 and 114, got: $surahId');
    }
  }

  /// Validate ayah ID within a surah
  static void validateAyahId(int ayahId, int maxAyat) {
    if (ayahId < 1 || ayahId > maxAyat) {
      throw ArgumentError(
          'Ayah ID must be between 1 and $maxAyat, got: $ayahId');
    }
  }

  /// Validate ayah range
  static void validateAyahRange(int startAyah, int endAyah, int maxAyat) {
    if (startAyah < 1 || startAyah > maxAyat) {
      throw ArgumentError(
          'Start ayah must be between 1 and $maxAyat, got: $startAyah');
    }

    if (endAyah < 1 || endAyah > maxAyat) {
      throw ArgumentError(
          'End ayah must be between 1 and $maxAyat, got: $endAyah');
    }

    if (startAyah > endAyah) {
      throw ArgumentError(
          'Start ayah ($startAyah) cannot be greater than end ayah ($endAyah)');
    }
  }

  /// Validate Juz number (1-30)
  static void validateJuzNumber(int juzNumber) {
    if (juzNumber < 1 || juzNumber > 30) {
      throw ArgumentError(
          'Juz number must be between 1 and 30, got: $juzNumber');
    }
  }

  /// Validate Hizb number (1-60)
  static void validateHizbNumber(int hizbNumber) {
    if (hizbNumber < 1 || hizbNumber > 60) {
      throw ArgumentError(
          'Hizb number must be between 1 and 60, got: $hizbNumber');
    }
  }

  /// Validate search term
  static void validateSearchTerm(String searchTerm) {
    if (searchTerm.trim().isEmpty) {
      throw ArgumentError('Search term cannot be empty');
    }
  }

  /// Validate revelation type
  static void validateRevelationType(String revelationType) {
    if (revelationType != 'Meccan' && revelationType != 'Medinan') {
      throw ArgumentError(
          'Revelation type must be "Meccan" or "Medinan", got: $revelationType');
    }
  }

  /// Validate revelation order (1-114)
  static void validateRevelationOrder(int revelationOrder) {
    if (revelationOrder < 1 || revelationOrder > 114) {
      throw ArgumentError(
          'Revelation order must be between 1 and 114, got: $revelationOrder');
    }
  }

  /// Validate number of ayat for a surah
  static void validateNumberOfAyahs(int numberOfAyahs) {
    if (numberOfAyahs < 3 || numberOfAyahs > 286) {
      throw ArgumentError(
          'Number of ayahs must be between 3 and 286, got: $numberOfAyahs');
    }
  }

  /// Validate pagination parameters
  static void validatePagination(int page, int limit) {
    if (page < 1) {
      throw ArgumentError('Page number must be at least 1, got: $page');
    }

    if (limit < 1 || limit > 1000) {
      throw ArgumentError('Limit must be between 1 and 1000, got: $limit');
    }
  }

  /// Validate that a value is not null
  static void validateNotNull(dynamic value, String paramName) {
    if (value == null) {
      throw ArgumentError('$paramName cannot be null');
    }
  }

  /// Validate that a string is not empty
  static void validateNotEmpty(String value, String paramName) {
    if (value.isEmpty) {
      throw ArgumentError('$paramName cannot be empty');
    }
  }

  /// Validate that a list is not empty
  static void validateListNotEmpty<T>(List<T> list, String paramName) {
    if (list.isEmpty) {
      throw ArgumentError('$paramName cannot be empty');
    }
  }

  /// Validate Arabic text format (basic check for Arabic characters)
  static bool isArabicText(String text) {
    // Basic regex to check if text contains Arabic characters
    final arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return arabicRegex.hasMatch(text);
  }

  /// Validate that text contains Arabic characters
  static void validateArabicText(String text, String paramName) {
    if (!isArabicText(text)) {
      throw ArgumentError('$paramName must contain Arabic text');
    }
  }

  /// Validate email format (for contact/feedback features)
  static void validateEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      throw ArgumentError('Invalid email format: $email');
    }
  }

  /// Validate URL format
  static void validateUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      throw ArgumentError('Invalid URL format: $url');
    }
  }

  /// Validate percentage value (0-100)
  static void validatePercentage(double percentage) {
    if (percentage < 0 || percentage > 100) {
      throw ArgumentError(
          'Percentage must be between 0 and 100, got: $percentage');
    }
  }

  /// Validate positive number
  static void validatePositive(num number, String paramName) {
    if (number <= 0) {
      throw ArgumentError('$paramName must be positive, got: $number');
    }
  }

  /// Validate non-negative number
  static void validateNonNegative(num number, String paramName) {
    if (number < 0) {
      throw ArgumentError('$paramName must be non-negative, got: $number');
    }
  }

  /// Validate that a number is within a specific range
  static void validateRange(num value, num min, num max, String paramName) {
    if (value < min || value > max) {
      throw ArgumentError(
          '$paramName must be between $min and $max, got: $value');
    }
  }

  /// Validate date range
  static void validateDateRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      throw ArgumentError('Start date cannot be after end date');
    }
  }

  /// Validate file extension
  static void validateFileExtension(
      String filePath, List<String> allowedExtensions) {
    final extension = filePath.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      throw ArgumentError(
          'File must have one of these extensions: ${allowedExtensions.join(', ')}');
    }
  }

  /// Validate JSON structure for Quran data
  static void validateQuranDataStructure(Map<String, dynamic> data) {
    // Check required top-level fields
    final requiredFields = ['version', 'source', 'surahs'];
    for (final field in requiredFields) {
      if (!data.containsKey(field)) {
        throw ArgumentError('Missing required field: $field');
      }
    }

    // Check surahs array
    final surahs = data['surahs'];
    if (surahs is! List) {
      throw ArgumentError('surahs must be a list');
    }

    if (surahs.length != 114) {
      throw ArgumentError(
          'surahs must contain exactly 114 entries, got: ${surahs.length}');
    }

    // Validate each surah structure
    for (int i = 0; i < surahs.length; i++) {
      final surah = surahs[i];
      if (surah is! Map<String, dynamic>) {
        throw ArgumentError('Surah at index $i must be a map');
      }

      validateSurahStructure(surah, i + 1);
    }
  }

  /// Validate individual surah structure
  static void validateSurahStructure(
      Map<String, dynamic> surah, int expectedId) {
    final requiredFields = [
      'id',
      'name',
      'englishName',
      'revelationType',
      'numberOfAyahs',
      'revelationOrder',
      'ayat'
    ];

    for (final field in requiredFields) {
      if (!surah.containsKey(field)) {
        throw ArgumentError('Surah missing required field: $field');
      }
    }

    // Validate specific fields
    final id = surah['id'];
    if (id != expectedId) {
      throw ArgumentError('Expected surah ID $expectedId, got: $id');
    }

    validateRevelationType(surah['revelationType']);
    validateRevelationOrder(surah['revelationOrder']);

    final numberOfAyahs = surah['numberOfAyahs'];
    validateNumberOfAyahs(numberOfAyahs);

    final ayat = surah['ayat'];
    if (ayat is! List) {
      throw ArgumentError('ayat must be a list');
    }

    if (ayat.length != numberOfAyahs) {
      throw ArgumentError(
          'ayat list length (${ayat.length}) must match numberOfAyahs ($numberOfAyahs)');
    }

    // Validate each ayah
    for (int i = 0; i < ayat.length; i++) {
      final ayah = ayat[i];
      if (ayah is! Map<String, dynamic>) {
        throw ArgumentError('Ayah at index $i must be a map');
      }

      validateAyahStructure(ayah, i + 1);
    }
  }

  /// Validate individual ayah structure
  static void validateAyahStructure(Map<String, dynamic> ayah, int expectedId) {
    final requiredFields = ['id', 'text', 'juz', 'hizb'];

    for (final field in requiredFields) {
      if (!ayah.containsKey(field)) {
        throw ArgumentError('Ayah missing required field: $field');
      }
    }

    final id = ayah['id'];
    if (id != expectedId) {
      throw ArgumentError('Expected ayah ID $expectedId, got: $id');
    }

    final text = ayah['text'];
    if (text is! String || text.isEmpty) {
      throw ArgumentError('Ayah text must be a non-empty string');
    }

    validateJuzNumber(ayah['juz']);
    validateHizbNumber(ayah['hizb']);

    // sajdah field is optional but if present must be boolean
    if (ayah.containsKey('sajdah') && ayah['sajdah'] is! bool) {
      throw ArgumentError('sajdah field must be boolean');
    }
  }
}

import 'package:test/test.dart';
import 'package:quran_data_dart/src/utils/extensions.dart';

void main() {
  group('ArabicStringExtensions', () {
    group('hasArabicCharacters', () {
      test('should detect Arabic characters', () {
        expect('السلام عليكم'.hasArabicCharacters, isTrue);
        expect('بسم الله'.hasArabicCharacters, isTrue);
        expect('الحمد لله رب العالمين'.hasArabicCharacters, isTrue);
      });

      test('should return false for non-Arabic text', () {
        expect('Hello World'.hasArabicCharacters, isFalse);
        expect('123456'.hasArabicCharacters, isFalse);
        expect(r'!@#$%^&*()'.hasArabicCharacters, isFalse);
      });

      test('should detect Arabic in mixed text', () {
        expect('Hello السلام'.hasArabicCharacters, isTrue);
        expect('123 بسم الله 456'.hasArabicCharacters, isTrue);
      });

      test('should handle empty string', () {
        expect(''.hasArabicCharacters, isFalse);
      });
    });

    group('isArabicText', () {
      test('should validate pure Arabic text', () {
        expect('السلام عليكم ورحمة الله وبركاته'.isArabicText, isTrue);
        expect('بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ'.isArabicText, isTrue);
      });

      test('should return false for mixed text', () {
        expect('Hello السلام'.isArabicText, isFalse);
        expect('السلام 123'.isArabicText, isFalse);
      });

      test('should return false for empty string', () {
        expect(''.isArabicText, isFalse);
      });

      test('should allow Arabic punctuation', () {
        expect('السلام عليكم، كيف حالك؟'.isArabicText, isTrue);
      });
    });

    group('withoutDiacritics', () {
      test('should remove Arabic diacritics', () {
        final withDiacritics = 'بِسْمِ اللَّهِ الرَّحْمَـٰنِ الرَّحِيمِ';
        final withoutDiacritics = withDiacritics.withoutDiacritics;
        expect(withoutDiacritics.contains('ِ'), isFalse); // No kasra
        expect(withoutDiacritics.contains('ْ'), isFalse); // No sukun
        expect(withoutDiacritics.contains('َ'), isFalse); // No fatha
        expect(withoutDiacritics.contains('ّ'), isFalse); // No shadda
      });

      test('should handle text without diacritics', () {
        expect('السلام عليكم'.withoutDiacritics, equals('السلام عليكم'));
      });

      test('should handle empty string', () {
        expect(''.withoutDiacritics, equals(''));
      });
    });

    group('normalizedForSearch', () {
      test('should normalize Arabic text for search', () {
        final normalized = 'بِسْمِ   اللَّهِ  الرَّحْمَـٰنِ الرَّحِيمِ'.normalizedForSearch;
        expect(normalized.contains('ِ'), isFalse); // Diacritics removed
        expect(normalized.contains('  '), isFalse); // Multiple spaces normalized
      });

      test('should trim whitespace', () {
        expect('  السلام عليكم  '.normalizedForSearch, equals('السلام عليكم'));
      });

      test('should normalize multiple spaces', () {
        expect('السلام     عليكم'.normalizedForSearch, equals('السلام عليكم'));
      });
    });

    group('isValidEmail', () {
      test('should validate correct email addresses', () {
        expect('user@example.com'.isValidEmail, isTrue);
        expect('test.email+tag@example.co.uk'.isValidEmail, isTrue);
        expect('user123@domain.org'.isValidEmail, isTrue);
      });

      test('should reject invalid email addresses', () {
        expect('invalid-email'.isValidEmail, isFalse);
        expect('user@'.isValidEmail, isFalse);
        expect('@domain.com'.isValidEmail, isFalse);
        expect('user@domain'.isValidEmail, isFalse);
      });
    });

    group('isValidUrl', () {
      test('should validate correct URLs', () {
        expect('https://www.example.com'.isValidUrl, isTrue);
        expect('http://example.com/path'.isValidUrl, isTrue);
        expect('https://subdomain.example.co.uk/path?query=value'.isValidUrl, isTrue);
      });

      test('should reject invalid URLs', () {
        expect('not-a-url'.isValidUrl, isFalse);
        expect('ftp://example.com'.isValidUrl, isFalse);
        expect('https://'.isValidUrl, isFalse);
      });
    });

    group('truncate', () {
      test('should truncate long strings', () {
        final longText = 'This is a very long string that should be truncated';
        expect(longText.truncate(20), equals('This is a very long ...'));
        expect(longText.truncate(10, ellipsis: '>>'), equals('This is a >>'));
      });

      test('should not truncate short strings', () {
        expect('Short'.truncate(10), equals('Short'));
      });

      test('should handle empty string', () {
        expect(''.truncate(5), equals(''));
      });
    });

    group('titleCase', () {
      test('should capitalize first letter of each word', () {
        expect('hello world'.titleCase, equals('Hello World'));
        expect('the quick brown fox'.titleCase, equals('The Quick Brown Fox'));
      });

      test('should handle single word', () {
        expect('hello'.titleCase, equals('Hello'));
      });

      test('should handle empty string', () {
        expect(''.titleCase, equals(''));
      });

      test('should handle multiple spaces', () {
        expect('hello  world'.titleCase, equals('Hello  World'));
      });
    });

    group('snakeCase', () {
      test('should convert camelCase to snake_case', () {
        expect('camelCase'.snakeCase, equals('camel_case'));
        expect('userName'.snakeCase, equals('user_name'));
        expect('XMLHttpRequest'.snakeCase, equals('x_m_l_http_request'));
      });

      test('should handle single word', () {
        expect('hello'.snakeCase, equals('hello'));
      });

      test('should handle already snake_case', () {
        expect('already_snake_case'.snakeCase, equals('already_snake_case'));
      });
    });

    group('camelCase', () {
      test('should convert snake_case to camelCase', () {
        expect('snake_case'.camelCase, equals('snakeCase'));
        expect('user_name'.camelCase, equals('userName'));
        expect('long_variable_name'.camelCase, equals('longVariableName'));
      });

      test('should convert kebab-case to camelCase', () {
        expect('kebab-case'.camelCase, equals('kebabCase'));
        expect('user-name'.camelCase, equals('userName'));
      });

      test('should handle spaces', () {
        expect('hello world'.camelCase, equals('helloWorld'));
        expect('the quick brown fox'.camelCase, equals('theQuickBrownFox'));
      });

      test('should handle single word', () {
        expect('hello'.camelCase, equals('hello'));
      });

      test('should handle empty string', () {
        expect(''.camelCase, equals(''));
      });
    });
  });

  group('QuranIntExtensions', () {
    group('isValidSurahId', () {
      test('should validate valid surah IDs', () {
        expect(1.isValidSurahId, isTrue);
        expect(114.isValidSurahId, isTrue);
        expect(50.isValidSurahId, isTrue);
      });

      test('should reject invalid surah IDs', () {
        expect(0.isValidSurahId, isFalse);
        expect(115.isValidSurahId, isFalse);
        expect((0 - 1).isValidSurahId, isFalse);
      });
    });

    group('isValidJuzNumber', () {
      test('should validate valid juz numbers', () {
        expect(1.isValidJuzNumber, isTrue);
        expect(30.isValidJuzNumber, isTrue);
        expect(15.isValidJuzNumber, isTrue);
      });

      test('should reject invalid juz numbers', () {
        expect(0.isValidJuzNumber, isFalse);
        expect(31.isValidJuzNumber, isFalse);
        expect((0 - 1).isValidJuzNumber, isFalse);
      });
    });

    group('isValidHizbNumber', () {
      test('should validate valid hizb numbers', () {
        expect(1.isValidHizbNumber, isTrue);
        expect(60.isValidHizbNumber, isTrue);
        expect(30.isValidHizbNumber, isTrue);
      });

      test('should reject invalid hizb numbers', () {
        expect(0.isValidHizbNumber, isFalse);
        expect(61.isValidHizbNumber, isFalse);
        expect((0 - 1).isValidHizbNumber, isFalse);
      });
    });

    group('hizbToJuz', () {
      test('should convert hizb to juz correctly', () {
        expect(1.hizbToJuz, equals(1)); // First hizb of juz 1
        expect(2.hizbToJuz, equals(1)); // Second hizb of juz 1
        expect(3.hizbToJuz, equals(2)); // First hizb of juz 2
        expect(4.hizbToJuz, equals(2)); // Second hizb of juz 2
        expect(59.hizbToJuz, equals(30)); // First hizb of juz 30
        expect(60.hizbToJuz, equals(30)); // Second hizb of juz 30
      });
    });

    group('juzToFirstHizb', () {
      test('should convert juz to first hizb correctly', () {
        expect(1.juzToFirstHizb, equals(1));
        expect(2.juzToFirstHizb, equals(3));
        expect(15.juzToFirstHizb, equals(29));
        expect(30.juzToFirstHizb, equals(59));
      });
    });

    group('juzToSecondHizb', () {
      test('should convert juz to second hizb correctly', () {
        expect(1.juzToSecondHizb, equals(2));
        expect(2.juzToSecondHizb, equals(4));
        expect(15.juzToSecondHizb, equals(30));
        expect(30.juzToSecondHizb, equals(60));
      });
    });

    group('isFirstHizbOfJuz', () {
      test('should identify first hizb of juz', () {
        expect(1.isFirstHizbOfJuz, isTrue);
        expect(3.isFirstHizbOfJuz, isTrue);
        expect(59.isFirstHizbOfJuz, isTrue);
      });

      test('should identify second hizb of juz', () {
        expect(2.isFirstHizbOfJuz, isFalse);
        expect(4.isFirstHizbOfJuz, isFalse);
        expect(60.isFirstHizbOfJuz, isFalse);
      });
    });

    group('companionHizb', () {
      test('should find companion hizb', () {
        expect(1.companionHizb, equals(2));
        expect(2.companionHizb, equals(1));
        expect(59.companionHizb, equals(60));
        expect(60.companionHizb, equals(59));
      });
    });

    group('ordinal', () {
      test('should format ordinal numbers correctly', () {
        expect(1.ordinal, equals('1st'));
        expect(2.ordinal, equals('2nd'));
        expect(3.ordinal, equals('3rd'));
        expect(4.ordinal, equals('4th'));
        expect(11.ordinal, equals('11th'));
        expect(12.ordinal, equals('12th'));
        expect(13.ordinal, equals('13th'));
        expect(21.ordinal, equals('21st'));
        expect(22.ordinal, equals('22nd'));
        expect(23.ordinal, equals('23rd'));
      });
    });

    group('toArabicNumerals', () {
      test('should convert to Arabic-Indic numerals', () {
        expect(0.toArabicNumerals, equals('٠'));
        expect(1.toArabicNumerals, equals('١'));
        expect(12.toArabicNumerals, equals('١٢'));
        expect(114.toArabicNumerals, equals('١١٤'));
        expect(2024.toArabicNumerals, equals('٢٠٢٤'));
      });
    });

    group('asReadingTime', () {
      test('should format minutes correctly', () {
        expect(1.asReadingTime, equals('1 minute'));
        expect(2.asReadingTime, equals('2 minutes'));
        expect(45.asReadingTime, equals('45 minutes'));
      });

      test('should format hours correctly', () {
        expect(60.asReadingTime, equals('1 hour'));
        expect(120.asReadingTime, equals('2 hours'));
      });

      test('should format hours and minutes', () {
        expect(61.asReadingTime, equals('1 hour 1 minute'));
        expect(90.asReadingTime, equals('1 hour 30 minutes'));
        expect(150.asReadingTime, equals('2 hours 30 minutes'));
      });
    });
  });

  group('QuranDoubleExtensions', () {
    group('roundToPlaces', () {
      test('should round to specified decimal places', () {
        final rounded = 3.14159.roundToPlaces(2);
        expect(rounded, greaterThan(3.0));
        expect(rounded, lessThan(4.0));

        final rounded2 = 2.7182.roundToPlaces(3);
        expect(rounded2, greaterThan(2.0));
        expect(rounded2, lessThan(3.0));
      });
    });

    group('toPercentage', () {
      test('should format as percentage', () {
        expect(0.75.toPercentage(), equals('0.8%'));
        expect(0.1234.toPercentage(decimals: 2), equals('0.12%'));
      });
    });

    group('asFileSize', () {
      test('should format bytes', () {
        expect(500.0.asFileSize, equals('500 B'));
      });

      test('should format kilobytes', () {
        expect(1536.0.asFileSize, equals('1.5 KB'));
      });

      test('should format megabytes', () {
        expect(1572864.0.asFileSize, equals('1.5 MB'));
      });

      test('should format gigabytes', () {
        expect(1610612736.0.asFileSize, equals('1.5 GB'));
      });
    });

    group('asDuration', () {
      test('should format minutes only', () {
        expect(45.0.asDuration, equals('45min'));
      });

      test('should format hours and minutes', () {
        expect(90.0.asDuration, equals('1h 30min'));
        expect(125.0.asDuration, equals('2h 5min'));
      });
    });
  });

  group('QuranListExtensions', () {
    group('random', () {
      test('should return random element from list', () {
        final list = [1, 2, 3, 4, 5];
        final random = list.random;
        expect(list.contains(random), isTrue);
      });

      test('should return null for empty list', () {
        final List<int> emptyList = [];
        expect(emptyList.random, isNull);
      });
    });

    group('getAtIndices', () {
      test('should return elements at specified indices', () {
        final list = ['a', 'b', 'c', 'd', 'e'];
        expect(list.getAtIndices([0, 2, 4]), equals(['a', 'c', 'e']));
        expect(list.getAtIndices([1, 3]), equals(['b', 'd']));
      });

      test('should ignore invalid indices', () {
        final list = ['a', 'b', 'c'];
        expect(list.getAtIndices([0, 5, 2, -1]), equals(['a', 'c']));
      });
    });

    group('chunked', () {
      test('should split list into chunks', () {
        final list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        expect(list.chunked(3), equals([[1, 2, 3], [4, 5, 6], [7, 8, 9]]));
        expect(list.chunked(4), equals([[1, 2, 3, 4], [5, 6, 7, 8], [9]]));
      });

      test('should throw error for invalid chunk size', () {
        final list = [1, 2, 3];
        expect(() => list.chunked(0), throwsA(isA<ArgumentError>()));
        expect(() => list.chunked(-1), throwsA(isA<ArgumentError>()));
      });
    });

    group('unique', () {
      test('should return unique elements preserving order', () {
        final list = [1, 2, 2, 3, 1, 4, 3];
        expect(list.unique, equals([1, 2, 3, 4]));
      });

      test('should handle list with no duplicates', () {
        final list = [1, 2, 3, 4];
        expect(list.unique, equals([1, 2, 3, 4]));
      });

      test('should handle empty list', () {
        final List<int> emptyList = [];
        expect(emptyList.unique, isEmpty);
      });
    });

    group('frequency', () {
      test('should count occurrences of each element', () {
        final list = ['a', 'b', 'a', 'c', 'b', 'a'];
        final freq = list.frequency;
        expect(freq['a'], equals(3));
        expect(freq['b'], equals(2));
        expect(freq['c'], equals(1));
      });
    });

    group('groupBy', () {
      test('should group elements by key function', () {
        final words = ['apple', 'ant', 'bee', 'cat', 'bat'];
        final grouped = words.groupBy((word) => word[0]);
        expect(grouped['a'], equals(['apple', 'ant']));
        expect(grouped['b'], equals(['bee', 'bat']));
        expect(grouped['c'], equals(['cat']));
      });
    });
  });

  group('QuranMapExtensions', () {
    group('getOrDefault', () {
      test('should return value if key exists', () {
        final map = {'a': 1, 'b': 2};
        expect(map.getOrDefault('a', 0), equals(1));
      });

      test('should return default if key does not exist', () {
        final map = {'a': 1, 'b': 2};
        expect(map.getOrDefault('c', 0), equals(0));
      });
    });

    group('where', () {
      test('should filter map by predicate', () {
        final map = {'a': 1, 'b': 2, 'c': 3, 'd': 4};
        final filtered = map.where((key, value) => value % 2 == 0);
        expect(filtered, equals({'b': 2, 'd': 4}));
      });
    });

    group('mapValues', () {
      test('should transform map values', () {
        final map = {'a': 1, 'b': 2, 'c': 3};
        final transformed = map.mapValues((value) => value * 2);
        expect(transformed, equals({'a': 2, 'b': 4, 'c': 6}));
      });
    });

    group('mapKeys', () {
      test('should transform map keys', () {
        final map = {'a': 1, 'b': 2, 'c': 3};
        final transformed = map.mapKeys((key) => key.toUpperCase());
        expect(transformed, equals({'A': 1, 'B': 2, 'C': 3}));
      });
    });

    group('merge', () {
      test('should merge maps without conflicts', () {
        final map1 = {'a': 1, 'b': 2};
        final map2 = {'c': 3, 'd': 4};
        final merged = map1.merge(map2);
        expect(merged, equals({'a': 1, 'b': 2, 'c': 3, 'd': 4}));
      });

      test('should handle conflicts with onConflict function', () {
        final map1 = {'a': 1, 'b': 2};
        final map2 = {'b': 3, 'c': 4};
        final merged = map1.merge(map2, onConflict: (current, other) => current + other);
        expect(merged, equals({'a': 1, 'b': 5, 'c': 4}));
      });

      test('should overwrite without onConflict function', () {
        final map1 = {'a': 1, 'b': 2};
        final map2 = {'b': 3, 'c': 4};
        final merged = map1.merge(map2);
        expect(merged, equals({'a': 1, 'b': 3, 'c': 4}));
      });
    });
  });

  group('QuranDateTimeExtensions', () {
    test('should check if date is today', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 10, 30);
      expect(today.isToday, isTrue);

      final yesterday = today.subtract(const Duration(days: 1));
      expect(yesterday.isToday, isFalse);
    });

    test('should check if date is yesterday', () {
      final now = DateTime.now();
      final yesterday = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);

      final today = DateTime.now();
      expect(today.isYesterday, isFalse);
    });

    test('should check if date is tomorrow', () {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
      expect(tomorrow.isTomorrow, isTrue);

      final today = DateTime.now();
      expect(today.isTomorrow, isFalse);
    });

    test('should calculate day of year', () {
      final jan1 = DateTime(2024, 1, 1);
      expect(jan1.dayOfYear, equals(1));

      final dec31 = DateTime(2024, 12, 31);
      expect(dec31.dayOfYear, equals(366)); // 2024 is a leap year
    });

    test('should format as time ago', () {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      expect(oneHourAgo.timeAgo, equals('1 hour ago'));

      final twoDaysAgo = now.subtract(const Duration(days: 2));
      expect(twoDaysAgo.timeAgo, equals('2 days ago'));

      final thirtyMinutesAgo = now.subtract(const Duration(minutes: 30));
      expect(thirtyMinutesAgo.timeAgo, equals('30 minutes ago'));
    });

    test('should format as Islamic date', () {
      final date = DateTime(2024, 1, 15);
      final islamicDate = date.asIslamicDate;
      expect(islamicDate, contains('1445 AH')); // Approximate
      expect(islamicDate, contains('15'));
    });
  });
}
/// Extensions for enhanced functionality throughout the Quran package.
library quran.utils.extensions;

/// Extensions on String for Arabic text handling.
extension ArabicStringExtensions on String {
  /// Check if the string contains Arabic characters
  bool get hasArabicCharacters {
    final arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return arabicRegex.hasMatch(this);
  }

  /// Check if the string is purely Arabic text
  bool get isArabicText {
    if (isEmpty) return false;
    final arabicRegex = RegExp(
        r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s\u060C\u061B\u061F\u0640\u064B-\u065F\u0670\u06D6-\u06ED]+$');
    return arabicRegex.hasMatch(this);
  }

  /// Remove diacritics from Arabic text
  String get withoutDiacritics {
    // Remove common Arabic diacritics
    return replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '');
  }

  /// Normalize Arabic text for search
  String get normalizedForSearch {
    return withoutDiacritics
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim()
        .toLowerCase();
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid URL
  bool get isValidUrl {
    final urlRegex = RegExp(
        r'^https?:\/\/([\w\-]+(\.[\w\-]+)+)([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$');
    return urlRegex.hasMatch(this);
  }

  /// Truncate string to specified length with ellipsis
  String truncate(int length, {String ellipsis = '...'}) {
    if (this.length <= length) return this;
    return '${substring(0, length)}$ellipsis';
  }

  /// Capitalize first letter of each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }

  /// Convert to snake_case
  String get snakeCase {
    return replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '');
  }

  /// Convert to camelCase
  String get camelCase {
    if (isEmpty) return this;
    final words = split(RegExp(r'[\s_-]+'));
    if (words.isEmpty) return this;

    return words.first.toLowerCase() +
        words
            .skip(1)
            .map((word) => word.isNotEmpty
                ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                : '')
            .join();
  }
}

/// Extensions on int for Quran-specific operations.
extension QuranIntExtensions on int {
  /// Check if the number is a valid surah ID (1-114)
  bool get isValidSurahId => this >= 1 && this <= 114;

  /// Check if the number is a valid Juz number (1-30)
  bool get isValidJuzNumber => this >= 1 && this <= 30;

  /// Check if the number is a valid Hizb number (1-60)
  bool get isValidHizbNumber => this >= 1 && this <= 60;

  /// Convert Hizb number to its parent Juz number
  int get hizbToJuz => ((this - 1) ~/ 2) + 1;

  /// Convert Juz number to its first Hizb number
  int get juzToFirstHizb => (this - 1) * 2 + 1;

  /// Convert Juz number to its second Hizb number
  int get juzToSecondHizb => (this - 1) * 2 + 2;

  /// Check if Hizb number is the first Hizb of its Juz
  bool get isFirstHizbOfJuz => this % 2 == 1;

  /// Check if Hizb number is the second Hizb of its Juz
  bool get isSecondHizbOfJuz => this % 2 == 0;

  /// Get the companion Hizb number (the other half of the same Juz)
  int get companionHizb => isFirstHizbOfJuz ? this + 1 : this - 1;

  /// Convert to ordinal string (1st, 2nd, 3rd, etc.)
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';

    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Convert to Arabic-Indic numerals
  String get toArabicNumerals {
    const arabicNumerals = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return toString().split('').map((digit) {
      final digitInt = int.tryParse(digit);
      return digitInt != null ? arabicNumerals[digitInt] : digit;
    }).join();
  }

  /// Format as reading time (e.g., "5 minutes", "1 hour 30 minutes")
  String get asReadingTime {
    if (this < 60) {
      return '$this minute${this == 1 ? '' : 's'}';
    }

    final hours = this ~/ 60;
    final minutes = this % 60;

    if (minutes == 0) {
      return '$hours hour${hours == 1 ? '' : 's'}';
    }

    return '$hours hour${hours == 1 ? '' : 's'} $minutes minute${minutes == 1 ? '' : 's'}';
  }
}

/// Extensions on double for formatting and calculations.
extension QuranDoubleExtensions on double {
  /// Round to specified decimal places
  double roundToPlaces(int places) {
    final factor = 1 / (1 / (10 * places));
    return (this * factor).round() / factor;
  }

  /// Convert to percentage string
  String toPercentage({int decimals = 1}) {
    return '${(this).toStringAsFixed(decimals)}%';
  }

  /// Format as file size (bytes to KB/MB/GB)
  String get asFileSize {
    if (this < 1024) return '${this.toStringAsFixed(0)} B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format as duration (minutes to hours:minutes)
  String get asDuration {
    final hours = this ~/ 60;
    final minutes = (this % 60).round();

    if (hours == 0) {
      return '${minutes}min';
    }

    return '${hours}h ${minutes}min';
  }
}

/// Extensions on List for common operations.
extension QuranListExtensions<T> on List<T> {
  /// Get a random element from the list
  T? get random {
    if (isEmpty) return null;
    final randomIndex = DateTime.now().millisecondsSinceEpoch % length;
    return this[randomIndex];
  }

  /// Get elements at specified indices
  List<T> getAtIndices(List<int> indices) {
    return indices
        .where((index) => index >= 0 && index < length)
        .map((index) => this[index])
        .toList();
  }

  /// Split list into chunks of specified size
  List<List<T>> chunked(int chunkSize) {
    if (chunkSize <= 0) throw ArgumentError('Chunk size must be positive');

    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += chunkSize) {
      final end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }

  /// Get unique elements while preserving order
  List<T> get unique {
    final seen = <T>{};
    return where((element) => seen.add(element)).toList();
  }

  /// Count occurrences of each element
  Map<T, int> get frequency {
    final freq = <T, int>{};
    for (final element in this) {
      freq[element] = (freq[element] ?? 0) + 1;
    }
    return freq;
  }

  /// Group elements by a key function
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    final groups = <K, List<T>>{};
    for (final element in this) {
      final key = keyFunction(element);
      groups.putIfAbsent(key, () => []).add(element);
    }
    return groups;
  }
}

/// Extensions on Map for common operations.
extension QuranMapExtensions<K, V> on Map<K, V> {
  /// Get value by key with default fallback
  V getOrDefault(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }

  /// Filter map by predicate
  Map<K, V> where(bool Function(K key, V value) predicate) {
    final filtered = <K, V>{};
    forEach((key, value) {
      if (predicate(key, value)) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  /// Transform map values
  Map<K, R> mapValues<R>(R Function(V value) transform) {
    final transformed = <K, R>{};
    forEach((key, value) {
      transformed[key] = transform(value);
    });
    return transformed;
  }

  /// Transform map keys
  Map<R, V> mapKeys<R>(R Function(K key) transform) {
    final transformed = <R, V>{};
    forEach((key, value) {
      transformed[transform(key)] = value;
    });
    return transformed;
  }

  /// Merge with another map
  Map<K, V> merge(Map<K, V> other,
      {V Function(V current, V other)? onConflict}) {
    final merged = Map<K, V>.from(this);
    other.forEach((key, value) {
      if (merged.containsKey(key) && onConflict != null) {
        final currentValue = merged[key];
        if (currentValue != null) {
          merged[key] = onConflict(currentValue, value);
        } else {
          merged[key] = value;
        }
      } else {
        merged[key] = value;
      }
    });
    return merged;
  }
}

/// Extensions on DateTime for Islamic calendar and formatting.
extension QuranDateTimeExtensions on DateTime {
  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get day of year (1-366)
  int get dayOfYear {
    final firstDayOfYear = DateTime(year, 1, 1);
    return difference(firstDayOfYear).inDays + 1;
  }

  /// Format as relative time (e.g., "2 days ago", "in 3 hours")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format as Islamic date format
  String get asIslamicDate {
    // This is a simplified format - a full Islamic calendar conversion would require more complex calculations
    const months = [
      'Muharram',
      'Safar',
      'Rabi\' al-awwal',
      'Rabi\' al-thani',
      'Jumada al-awwal',
      'Jumada al-thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhu al-Qi\'dah',
      'Dhu al-Hijjah'
    ];

    // Simplified approximation - not accurate Islamic calendar
    final islamicYear = year - 579;
    final monthName = months[(month - 1) % 12];

    return '$day $monthName $islamicYear AH';
  }
}

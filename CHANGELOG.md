# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.2] - 2024-12-15

### Fixed
- Fixed dangling library doc comment in extensions.dart
- Fixed null check operator on potentially nullable type parameter in Map.merge extension

## [1.5.1] - 2024-12-15

### Changed
- Updated flutter_lints from ^2.0.0 to ^6.0.0 for latest linting rules
- Updated collection dependency to ^1.19.0

## [1.5.0] - 2024-12-15

### Added
- Initial release of the comprehensive Quran data package
- Complete Quran text with Arabic content for all 114 surahs
- Ayah-level data with Juz and Hizb information
- Sajdah (prostration) markers for relevant ayahs
- Surah metadata including names, revelation type, and statistics
- Search functionality for finding specific text
- Range operations for extracting ayah ranges
- Data validation utilities
- Comprehensive model classes with proper typing
- Offline-first design for Flutter applications

### Features
- 6,236 ayahs across 114 surahs
- Meccan and Medinan surah classification
- Juz (Para) and Hizb divisions
- Sajdah ayah identification
- Text search with relevance scoring
- Ayah range extraction
- Surah statistics and metadata
- Data integrity validation
- Memory-efficient data loading
- Cross-platform compatibility (Android, iOS, Web, Desktop)

### Technical Details
- Built with Dart SDK 2.17.0+ compatibility
- Flutter 3.0.0+ support
- Comprehensive test coverage
- Type-safe model implementations
- Efficient data structures
- Asset-based data storage
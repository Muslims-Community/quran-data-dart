# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.7.1] - 2025-09-20

### Fixed
- Fixed linting issue in extensions.dart - added curly braces around if statement body to comply with lints_core rules

## [1.7.0] - 2024-12-15

### Added
- **Developer Experience Enhancements**:
  - Multiple comprehensive example applications (CLI, search, comprehensive usage)
  - Detailed contribution guidelines (CONTRIBUTING.md)
  - GitHub Actions CI/CD pipeline with automated testing
  - Code coverage reporting and analysis
  - Automated documentation generation

- **Documentation Improvements**:
  - Enhanced API documentation with detailed dartdoc comments
  - Fixed package import references throughout documentation
  - Added real-world usage examples for all major features
  - Comprehensive code examples showing best practices

- **Infrastructure**:
  - GitHub Actions workflow for automated testing across Dart versions
  - Automated pub.dev package analysis and scoring
  - Documentation deployment to GitHub Pages
  - Quality gates for code formatting and analysis

### Improved
- Package discoverability through better documentation
- Developer onboarding experience
- Code quality assurance through automated checks
- Community contribution process

## [1.6.0] - 2024-12-15

### Added
- Comprehensive test suite with 93+ tests covering:
  - Unit tests for all QuranService core methods
  - Model validation and serialization tests
  - Extension method tests for Arabic text handling
  - Integration tests for search functionality
- Test configuration with dart_test.yaml
- Automated test runner for all test suites
- Extensive test coverage for error handling and edge cases

### Improved
- Enhanced code quality and reliability through testing
- Better validation of API responses and data integrity
- Comprehensive testing of Arabic text processing capabilities

## [1.5.3] - 2024-12-15

### Fixed
- Fixed README.md package name references from 'quran' to 'quran_data_dart'
- Fixed import statements in documentation examples
- Fixed pub.dev badge URLs in README.md
- Updated installation version to current version

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
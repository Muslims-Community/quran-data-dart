# Contributing to Quran Data Dart

Thank you for your interest in contributing to Quran Data Dart! This package aims to provide comprehensive, authentic Quranic data for Dart and Flutter applications.

## 🕌 Islamic Guidelines

When contributing to this project, please keep in mind:

- **Respectful Treatment**: Always handle Quranic text and Islamic content with utmost respect
- **Authenticity**: Ensure any Quranic text additions or modifications are authentic and properly sourced
- **Attribution**: Maintain proper attribution to the Tanzil Project and other sources
- **Reverent Approach**: Approach the code with the understanding that it serves a sacred purpose

## 🚀 Getting Started

### Prerequisites

- **Dart SDK**: Version 3.0.0 or higher
- **Git**: For version control
- **IDE**: VS Code, IntelliJ, or any Dart-compatible editor

### Setting Up Development Environment

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/quran-data-dart.git
   cd quran-data-dart
   ```

2. **Install Dependencies**
   ```bash
   dart pub get
   ```

3. **Verify Setup**
   ```bash
   dart analyze
   dart test
   dart format .
   ```

## 📝 Development Workflow

### 1. Code Style and Standards

- **Formatting**: Use `dart format .` before committing
- **Analysis**: Ensure `dart analyze` passes with no issues
- **Documentation**: Write comprehensive dartdoc comments for public APIs
- **Naming**: Follow Dart naming conventions (camelCase, PascalCase, etc.)

### 2. Testing Requirements

All contributions must include appropriate tests:

```bash
# Run all tests
dart test

# Run specific test file
dart test test/models/ayah_test.dart

# Run with coverage
dart test --coverage=coverage
```

**Test Categories:**
- **Unit Tests**: For individual functions and classes
- **Integration Tests**: For complete workflows
- **Model Tests**: For data serialization/deserialization
- **Extension Tests**: For utility extensions

### 3. Code Review Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/description-of-feature
   ```

2. **Make Changes**
   - Write clean, documented code
   - Add comprehensive tests
   - Update documentation as needed

3. **Commit with Conventional Commits**
   ```bash
   git commit -m "feat: add new search functionality"
   git commit -m "fix: resolve ayah range validation bug"
   git commit -m "docs: update API documentation"
   ```

4. **Push and Create PR**
   ```bash
   git push origin feature/description-of-feature
   ```

## 🎯 Contribution Areas

### High Priority Areas

1. **Testing Enhancement**
   - Increase test coverage
   - Add edge case testing
   - Performance testing

2. **Documentation Improvement**
   - API documentation enhancement
   - Usage examples
   - Tutorial content

3. **Performance Optimization**
   - Search algorithm improvements
   - Memory usage optimization
   - Loading time reduction

4. **Feature Additions**
   - Advanced search filters
   - Reading plan generators
   - Export functionality
   - Navigation helpers

### Code Organization

```
lib/
├── models/           # Data models (Ayah, Surah, etc.)
├── src/
│   ├── utils/       # Utility functions and extensions
│   ├── quran_service.dart    # Main service class
│   └── quran_data_loader.dart # Data loading logic
└── quran.dart       # Main library export

test/
├── models/          # Model tests
├── services/        # Service tests
├── utils/           # Utility tests
└── test_runner.dart # Test orchestration

example/             # Usage examples
├── lib/main.dart    # Main example
├── search_example.dart
└── cli_example.dart
```

## 🔧 Development Guidelines

### API Design Principles

1. **Simplicity**: Keep APIs simple and intuitive
2. **Consistency**: Maintain consistent naming and patterns
3. **Documentation**: Every public API must have comprehensive docs
4. **Error Handling**: Provide clear, helpful error messages
5. **Performance**: Optimize for both memory and speed

### Example of Good API Documentation

```dart
/// Searches for Arabic text within the Quran.
///
/// [searchTerm] The Arabic text to search for. Must not be empty.
///
/// Returns a [SearchResult] containing all matching ayat with their
/// complete surah information and metadata.
///
/// Throws [ArgumentError] if [searchTerm] is empty or only whitespace.
///
/// The search is performed on the original Arabic text and is case-sensitive.
/// For normalized search, use the text processing extensions first.
///
/// Example:
/// ```dart
/// // Search for mentions of Allah
/// final results = await QuranService.searchText('الله');
/// print('Found ${results.totalResults} ayat');
///
/// // Process results
/// for (final ayah in results.results) {
///   print('${ayah.surah.englishName} ${ayah.id}: ${ayah.text}');
/// }
/// ```
///
/// See also:
/// * [searchBySurahName] for searching surah names
/// * [ArabicStringExtensions] for text processing utilities
static Future<SearchResult> searchText(String searchTerm) async {
  // Implementation...
}
```

### Testing Best Practices

1. **Comprehensive Coverage**
   ```dart
   group('searchText', () {
     test('should find ayat containing search term', () async {
       final results = await QuranService.searchText('الله');
       expect(results.totalResults, greaterThan(0));
       expect(results.searchTerm, equals('الله'));
     });

     test('should throw ArgumentError for empty search term', () async {
       expect(
         () async => await QuranService.searchText(''),
         throwsA(isA<ArgumentError>()),
       );
     });

     test('should handle special Arabic characters', () async {
       final results = await QuranService.searchText('بِسْمِ');
       expect(results.results.isNotEmpty, isTrue);
     });
   });
   ```

2. **Integration Testing**
   ```dart
   test('should maintain data integrity across operations', () async {
     final surah = await QuranService.getSurah(2);
     final ayah = await QuranService.getAyah(2, 1);

     expect(ayah.surah.id, equals(surah.id));
     expect(ayah.surah.englishName, equals(surah.englishName));
   });
   ```

## 📚 Documentation Standards

### Dartdoc Comments

- Use `///` for all public APIs
- Include parameter descriptions
- Provide usage examples
- Document exceptions
- Add cross-references with `[ClassName]` or `[methodName]`

### README Updates

When adding new features:
1. Update the feature list
2. Add usage examples
3. Update installation instructions if needed
4. Maintain the table of contents

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Dart/Flutter version**
2. **Package version**
3. **Platform** (iOS, Android, Web, Desktop)
4. **Minimal reproduction code**
5. **Expected vs actual behavior**
6. **Stack trace** (if applicable)

## ✨ Feature Requests

For new features, please provide:

1. **Clear description** of the feature
2. **Use case** and motivation
3. **Proposed API** (if applicable)
4. **Islamic context** (if relevant)
5. **Implementation suggestions**

## 🔍 Code Review Checklist

Before submitting your PR, ensure:

- [ ] Code is properly formatted (`dart format .`)
- [ ] Analysis passes (`dart analyze`)
- [ ] All tests pass (`dart test`)
- [ ] New features have tests
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Commit messages follow conventional commits
- [ ] Code respects Islamic guidelines
- [ ] Performance impact is considered

## 🏆 Recognition

Contributors will be recognized in:
- `CHANGELOG.md` for their contributions
- GitHub contributor graph
- Special mentions for significant contributions

## 📞 Getting Help

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and community chat
- **Code Review**: We're happy to help with code review

## 📜 License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

*May Allah reward all those who contribute to spreading Islamic knowledge through technology.*

**JazakAllahu Khairan** for your interest in contributing! 🤲
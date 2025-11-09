# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Professional README.md with comprehensive documentation
- Russian version of README (README.ru.md)
- pyproject.toml for modern Python packaging
- LICENSE file (MIT)
- CONTRIBUTING.md with contribution guidelines
- SECURITY.md with security policies
- CHANGELOG.md (this file)

### Changed
- Improved project structure and organization
- Enhanced documentation for all spiders

## [0.1.0] - 2025-01-09

### Added
- Initial release of zbze-crawler
- Spider for Адыгэ Псалъэ (apkbr.ru) - `apkbr_ru`
- Spider for Адыгэ Псалъэ RSS feed - `apkbr_ru_feed`
- Spider for Kabardino-Balkaria news (elgkbr.ru) - `elgkbr_ru`
- Spider for Iуащхьэмахуэ journal (smikbr.ru) - `oshhamaho`
- JSON Lines export format
- TinyDB database storage
- HTML archiving capability
- HTTP caching to avoid duplicate downloads
- Auto-throttle mechanism for respectful crawling
- robots.txt compliance
- Data extraction for:
  - Article title
  - Publication date
  - Author information
  - Full text content
  - Source URL and metadata

### Features
- Multiple storage formats (JSON Lines, TinyDB, HTML)
- Incremental crawling with deduplication
- Configurable download delays
- Concurrent request management
- Link extraction and following
- Customizable spider settings

### Dependencies
- beautifulsoup4 >= 4.11.2
- requests >= 2.28.2
- scrapy >= 2.11.0
- tinydb >= 4.8.0
- pip-tools >= 7.3.0

---

## Version History

### [0.1.0] - 2025-01-09
- Initial public release
- Core spider functionality
- Multiple Kabardian language sources
- Production-ready crawling

---

## Upgrade Guide

### From Development to 0.1.0

If you were using an early development version:

1. Update dependencies:
   ```bash
   pip install -r requirements.in
   ```

2. No breaking changes in spider API

3. Data format remains compatible

---

## Roadmap

### Planned for 0.2.0
- [ ] Additional source websites
- [ ] Enhanced metadata extraction
- [ ] Improved error handling
- [ ] Spider statistics and reporting
- [ ] CLI tool for managing spiders
- [ ] Automated testing suite

### Planned for 0.3.0
- [ ] Data validation and quality checks
- [ ] Export to additional formats (CSV, XML)
- [ ] Web dashboard for monitoring
- [ ] Scheduling and automation tools
- [ ] Integration with zbze_ocr pipeline

### Planned for 1.0.0
- [ ] Stable API
- [ ] Complete documentation
- [ ] CI/CD pipeline
- [ ] Docker support
- [ ] Comprehensive test coverage
- [ ] Performance optimizations

---

## Notes

- This project focuses on collecting publicly available Kabardian language texts
- All data collection respects copyright and usage terms of source websites
- Data is intended for academic and research purposes only

---

**For detailed commit history, see the [GitHub commit log](https://github.com/zbze-org/zbze-crawler/commits/main).**

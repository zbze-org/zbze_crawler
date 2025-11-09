# Contributing to zbze-crawler

Thank you for your interest in contributing to zbze-crawler! This document provides guidelines and instructions for contributing to the project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Enhancements](#suggesting-enhancements)
  - [Adding New Sources](#adding-new-sources)
  - [Pull Requests](#pull-requests)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Commit Guidelines](#commit-guidelines)

## Code of Conduct

This project is dedicated to providing a welcoming and inclusive experience for everyone. We expect all participants to:

- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When creating a bug report, include as many details as possible:

- **Clear title and description**
- **Steps to reproduce** the behavior
- **Expected behavior** vs actual behavior
- **Environment details** (OS, Python version, Scrapy version)
- **Spider name** that encountered the issue
- **Sample URLs** that trigger the issue (if applicable)
- **Logs** with relevant error messages

**Example bug report:**

```markdown
**Spider:** apkbr_ru
**Issue:** Spider fails to extract publication date
**URL:** https://apkbr.ru/node/12345
**Error:** AttributeError: 'NoneType' object has no attribute 'get'
**Steps to reproduce:**
1. Run `scrapy crawl apkbr_ru`
2. Observer error when processing the URL above
```

### Suggesting Enhancements

Enhancement suggestions are welcome! Please create an issue with:

- **Clear use case** - Why would this enhancement be useful?
- **Proposed solution** - How would you implement this?
- **Alternatives considered** - What other approaches did you think about?
- **Impact** - Who would benefit from this enhancement?

**Example enhancement suggestion:**

```markdown
**Enhancement:** Add support for image extraction
**Use case:** Collect images alongside text for visual corpus
**Proposed solution:**
1. Add image pipeline to settings.py
2. Extract image URLs in spider
3. Download and store images with metadata
**Alternatives:** Use Scrapy's built-in ImagesPipeline
```

### Adding New Sources

To add a new Kabardian language source:

1. **Verify Source Eligibility:**
   - Content is publicly available
   - Contains Kabardian language text
   - Has clear usage/copyright terms
   - Is suitable for academic research

2. **Create a New Spider:**
   ```bash
   cd zbze_scrapy
   scrapy genspider source_name domain.com
   ```

3. **Implement Extraction Logic:**
   - Follow existing spider patterns (see `apkbr_ru.py`)
   - Extract: title, content, author, date, URL
   - Save to JSON Lines and TinyDB
   - Add HTML archiving if needed

4. **Test Your Spider:**
   ```bash
   scrapy crawl source_name -s CLOSESPIDER_PAGECOUNT=10
   ```

5. **Document the Source:**
   - Add to README.md source table
   - Include copyright/usage terms
   - Provide example URLs

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following the coding guidelines below
3. **Test your spider** with sample data
4. **Update documentation** if you're adding features or sources
5. **Run linters** with `ruff check zbze_scrapy/`
6. **Commit with conventional commits** format (see below)
7. **Submit your pull request**

**Pull request checklist:**

- [ ] Code follows project style guidelines
- [ ] Spider has been tested on at least 50 pages
- [ ] Documentation has been updated
- [ ] Copyright/usage terms are documented
- [ ] Commit messages follow conventional commits

## Development Setup

### Prerequisites

- Python 3.10+
- pip or pip-tools

### Installation

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/zbze-crawler.git
cd zbze-crawler

# Install dependencies
pip install -r requirements.in

# Or use pip-tools for development
pip install pip-tools
pip-compile requirements.in
pip-sync
```

### Running Spiders

```bash
cd zbze_scrapy

# List available spiders
scrapy list

# Run a spider with limited pages (for testing)
scrapy crawl apkbr_ru -s CLOSESPIDER_PAGECOUNT=10

# Run with debug logging
scrapy crawl apkbr_ru -L DEBUG
```

### Project Structure

```
zbze-crawler/
├── zbze_scrapy/              # Scrapy project
│   ├── zbze_scrapy/
│   │   ├── spiders/          # Spider definitions
│   │   │   ├── apkbr_ru.py   # Example spider
│   │   │   └── ...
│   │   ├── items.py          # Data models
│   │   ├── pipelines.py      # Processing pipelines
│   │   └── settings.py       # Project settings
│   └── scrapy.cfg
├── data/                     # Collected data (gitignored)
└── requirements.in           # Dependencies
```

## Coding Guidelines

### Python Style

- **Follow PEP 8** with line length of 100 characters
- **Use type hints** where applicable
- **Write docstrings** for classes and complex methods
- **Use meaningful variable names**

### Spider Development

1. **Follow Existing Patterns:**
   - Use `CrawlSpider` for following links
   - Implement `parse_item()` for data extraction
   - Use CSS selectors over XPath when possible

2. **Data Extraction:**
   ```python
   def parse_item(self, response):
       item = {
           'url': response.url,
           'title': response.css('h1.title::text').get(),
           'date': response.css('span.date::attr(content)').get(),
           'content': ''.join(response.css('div.body ::text').getall()),
           'author': response.css('div.author::text').get(),
       }

       # Save to both formats
       self.exporter.export_item(item)
       self.save_to_db(item)

       yield item
   ```

3. **Error Handling:**
   - Use `.get()` for optional fields
   - Handle missing data gracefully
   - Log errors with context

4. **Respectful Crawling:**
   - Honor robots.txt
   - Set appropriate download delays
   - Use auto-throttle
   - Implement caching

### Code Quality

```bash
# Format code
ruff check zbze_scrapy/ --fix

# Check for issues
ruff check zbze_scrapy/

# Sort imports
ruff check zbze_scrapy/ --select I --fix
```

## Commit Guidelines

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature (new spider, new extraction field)
- **fix**: Bug fix (fix extraction logic, fix error handling)
- **docs**: Documentation changes
- **style**: Code style changes (formatting, no functional changes)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks (dependencies, configuration)

### Examples

```bash
# Adding a new spider
feat(spiders): add new spider for example.com

Add spider for collecting Kabardian texts from example.com.
Extracts title, content, author, and publication date.

Closes #123

# Fixing extraction logic
fix(apkbr_ru): fix publication date extraction

The CSS selector was incorrect, causing dates to be None.
Updated to use the correct attribute selector.

# Documentation update
docs(readme): update installation instructions

Add pip-tools installation method and improve examples.

# Refactoring
refactor(spiders): extract common database logic

Create base spider class with shared TinyDB and JSONL logic
to reduce code duplication across spiders.
```

### Commit Message Guidelines

- Use the imperative mood ("add feature" not "added feature")
- First line should be 50 characters or less
- Reference issues and pull requests in the footer
- Include motivation for the change in the body

## Testing

### Manual Testing

Test your spider before submitting:

```bash
# Test with limited pages
scrapy crawl YOUR_SPIDER -s CLOSESPIDER_PAGECOUNT=10

# Verify data quality
head data/YOUR_SPIDER/YOUR_SPIDER.jsonl

# Check for common issues
# - Missing data in required fields
# - Incorrect encoding
# - HTML tags in extracted text
# - Duplicate entries
```

### Validation Checklist

- [ ] Title is extracted correctly
- [ ] Content is clean (no HTML tags)
- [ ] Date format is consistent
- [ ] Author is extracted (if available)
- [ ] No duplicate URLs in database
- [ ] Links are followed correctly
- [ ] Respects robots.txt
- [ ] Download delay is appropriate

## Questions?

If you have questions about contributing, please:

1. Check existing issues and discussions
2. Open a new issue with the "question" label
3. Contact the maintainer at a.panagoa@gmail.com

## License

By contributing to zbze-crawler, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to the preservation of the Kabardian language!

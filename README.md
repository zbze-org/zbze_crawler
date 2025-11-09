# zbze-crawler

<div align="center">

**Web Crawler for Collecting Kabardian Language Texts**

[![Python Version](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![Scrapy](https://img.shields.io/badge/scrapy-2.11+-green.svg)](https://scrapy.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Features](#features) • [Installation](#installation) • [Quick Start](#quick-start) • [Documentation](#documentation) • [Contributing](#contributing)

---

🌐 **[Русская версия](README.ru.md)** | English

</div>

## Overview

`zbze-crawler` is a Scrapy-based web crawler designed to collect and preserve texts in the **Kabardian language** from publicly available online sources. This project supports linguistic research, language preservation, and the development of natural language processing tools for the Kabardian language.

### Key Features

- 🕷️ **Multiple Spiders** - Specialized crawlers for different Kabardian news sources
- 📰 **News Collection** - Automated harvesting of articles, publications, and journals
- 💾 **Multiple Storage Formats** - JSON Lines, TinyDB, and HTML archives
- 🔄 **Incremental Crawling** - HTTP caching to avoid re-downloading content
- 🎯 **Respectful Crawling** - robots.txt compliance and rate limiting
- 📊 **Structured Data** - Extracts title, content, author, date, and metadata
- 🌐 **Production-Ready** - Tested on thousands of pages

## Features

### Supported Sources

The crawler includes dedicated spiders for:

| Source | Description | Spider Name |
|--------|-------------|-------------|
| [Адыгэ Псалъэ](http://www.apkbr.ru/) | Electronic newspaper in Kabardian | `apkbr_ru` |
| [Адыгэ Псалъэ RSS](http://www.apkbr.ru/) | RSS feed crawler | `apkbr_ru_feed` |
| [Kabardino-Balkaria](https://elgkbr.ru/newskab) | News in Kabardian language | `elgkbr_ru` |
| [Iуащхьэмахуэ (Elbrus)](https://smikbr.ru/oshhamaho) | Cultural journal | `oshhamaho` |

### Data Collection

- **Article Extraction**
  - Title and headline
  - Publication date
  - Author information
  - Full text content
  - Source URL and metadata

- **Storage Options**
  - JSON Lines (.jsonl) - One article per line
  - TinyDB (.json) - Queryable document database
  - Raw HTML archives for backup

- **Crawler Features**
  - Auto-throttling to respect server limits
  - HTTP caching to avoid duplicate requests
  - Link extraction and following
  - Duplicate detection and prevention

## Installation

### Prerequisites

**System Requirements:**

| Tool | Description | Min Version |
|------|-------------|-------------|
| [Python](https://www.python.org/) | Programming language | 3.10+ |
| [uv](https://docs.astral.sh/uv/) | Fast Python package installer | Latest |

**Install uv:**

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or with pip
pip install uv
```

### Install Dependencies

**Using Makefile (recommended):**

```bash
# Clone the repository
git clone https://github.com/zbze-org/zbze-crawler.git
cd zbze-crawler

# Create venv and install dependencies
make install

# Or install with dev dependencies
make install-dev
```

**Manual installation with uv:**

```bash
# Create virtual environment
uv venv .venv

# Activate virtual environment
source .venv/bin/activate  # Unix/macOS
# or
.venv\Scripts\activate     # Windows

# Install dependencies
uv pip install -r requirements.in
```

### Verify Installation

```bash
# List available spiders
make list-spiders
```

Expected output:
```
apkbr_ru
apkbr_ru_feed
elgkbr_ru
oshhamaho
```

## Quick Start

### Run a Spider

**Using Makefile (recommended):**

```bash
# Run a single spider
make crawl-apkbr

# Or other spiders
make crawl-elgkbr
make crawl-oshhamaho

# Run all spiders
make crawl-all
```

**Direct scrapy command:**

```bash
# Activate virtual environment first
source .venv/bin/activate

# Navigate to Scrapy project directory
cd zbze_scrapy

# Run a single spider
scrapy crawl apkbr_ru

# Run with specific settings
scrapy crawl elgkbr_ru -s DOWNLOAD_DELAY=1
```

### Output Location

Collected data is saved to `data/` directory:

```
data/
├── apkbr_ru/
│   ├── apkbr_ru.jsonl      # JSON Lines format
│   ├── apkbr_ru.json       # TinyDB database
│   └── *.html              # Raw HTML files
├── elgkbr_ru/
│   └── ...
└── oshhamaho/
    └── ...
```

### View Collected Data

```bash
# View JSON Lines (one article per line)
head data/apkbr_ru/apkbr_ru.jsonl

# Query TinyDB (Python)
python -c "
from tinydb import TinyDB
db = TinyDB('data/apkbr_ru/apkbr_ru.json')
print(f'Total articles: {len(db.all())}')
"

# Count collected articles
wc -l data/apkbr_ru/apkbr_ru.jsonl
```

## Configuration

### Spider Settings

Configure crawling behavior in `zbze_scrapy/settings.py`:

```python
# Download delay between requests (seconds)
DOWNLOAD_DELAY = 0.25

# Concurrent requests per domain
CONCURRENT_REQUESTS_PER_DOMAIN = 8

# Enable HTTP caching
HTTPCACHE_ENABLED = True

# Auto-throttle settings
AUTOTHROTTLE_ENABLED = True
AUTOTHROTTLE_START_DELAY = 5
AUTOTHROTTLE_MAX_DELAY = 60
```

### Custom Spider

Create a new spider for additional sources:

```bash
cd zbze_scrapy
scrapy genspider example example.com
```

Then edit `zbze_scrapy/spiders/example.py` to customize extraction logic.

## Usage Examples

### Example 1: Collect All Sources

```bash
#!/bin/bash
cd zbze_scrapy

# Run all spiders sequentially
for spider in apkbr_ru elgkbr_ru oshhamaho; do
    echo "Running $spider..."
    scrapy crawl $spider
done
```

### Example 2: Scheduled Crawling

```bash
# Add to crontab for daily collection at 2 AM
0 2 * * * cd /path/to/zbze_crawler/zbze_scrapy && scrapy crawl apkbr_ru
```

### Example 3: Export to CSV

```bash
cd zbze_scrapy

# Export to CSV format
scrapy crawl apkbr_ru -o ../data/apkbr_ru/output.csv -t csv
```

### Example 4: Process Collected Data (Python)

```python
import json

# Read JSON Lines file
articles = []
with open('data/apkbr_ru/apkbr_ru.jsonl', 'r', encoding='utf-8') as f:
    for line in f:
        article = json.loads(line)
        articles.append(article)

# Print statistics
print(f"Total articles: {len(articles)}")
print(f"Sample article: {articles[0]['title']}")
```

## Project Structure

```
zbze-crawler/
├── zbze_scrapy/              # Scrapy project
│   ├── zbze_scrapy/
│   │   ├── spiders/          # Spider definitions
│   │   │   ├── apkbr_ru.py
│   │   │   ├── apkbr_ru_feed.py
│   │   │   ├── elgkbr_ru.py
│   │   │   └── oshhamaho.py
│   │   ├── items.py          # Data models
│   │   ├── pipelines.py      # Processing pipelines
│   │   ├── middlewares.py    # Custom middlewares
│   │   └── settings.py       # Project settings
│   └── scrapy.cfg            # Scrapy configuration
│
├── data/                     # Collected data (gitignored)
│   ├── apkbr_ru/
│   ├── elgkbr_ru/
│   └── oshhamaho/
│
├── requirements.in           # Python dependencies
├── README.md                 # This file
├── README.ru.md              # Russian version
└── LICENSE                   # License information
```

## Copyright and Usage Terms

### Source: http://www.apkbr.ru

> Information from this website may be used exclusively under the following conditions:
> - A link to http://www.apkbr.ru must be provided at the end of the text
> - Modification of texts is not permitted; text must be copied in its original form
> - Removal of the link to this website from material texts is not allowed

### Source: http://www.elgkbr.ru

> Information from this website may be used exclusively under the following conditions:
> - A link to http://www.elgkbr.ru must be provided at the end of the text
> - Modification of texts is not permitted; text must be copied in its original form
> - Removal of the link to this website from material texts is not allowed

### Source: https://smikbr.ru

> Information from this website may be used exclusively under the following conditions:
> - A link to the SMI KBR Portal is MANDATORY when reprinting materials

## Academic Use

Materials and data presented in this project are intended exclusively for academic use and research. They may be useful for linguists, researchers, and students interested in studying the Kabardian language, its structure, history, and development.

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### How to Contribute

- **Add New Sources** - Create spiders for additional Kabardian websites
- **Improve Extraction** - Enhance parsing logic for better data quality
- **Report Issues** - Submit bug reports and feature requests
- **Documentation** - Improve guides and examples

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Adam Panagov**
- Email: a.panagoa@gmail.com
- GitHub: [@zbze-org](https://github.com/zbze-org)

## Acknowledgments

- **Source websites** for providing valuable content in Kabardian language
- **Scrapy** for the excellent web crawling framework
- **Kabardian language community** for supporting preservation efforts
- **zbze-org contributors** for testing and feedback

## Related Projects

### zbze-org Ecosystem

This crawler is part of a four-project ecosystem for Kabardian language digitization:

| Project | Purpose | Repository |
|---------|---------|------------|
| **zbze-crawler** (this) | Web crawler for collecting Kabardian texts from online sources | [GitHub](https://github.com/zbze-org/zbze-crawler) |
| **tesseract-kbd-model** | Distributable Tesseract OCR models for Kabardian language | [GitHub](https://github.com/zbze-org/tesseract-kbd-model) |
| **zbze_ocr** | Training infrastructure with Airflow, notebooks, and data preparation | [GitHub](https://github.com/zbze-org/zbze_ocr) |
| **zbze_ocr_cli** | Production-ready OCR CLI tool with advanced image processing | [GitHub](https://github.com/zbze-org/zbze_ocr_cli) |

**Project Workflow:**
```
zbze-crawler (this)                → Data Collection
    ├── Collects web texts          ↓
    └── Provides corpus data   zbze_ocr → Training Infrastructure
                                    ├── Trains models
                                    └── Exports to  tesseract-kbd-model → Models
                                                    ↓
                                               zbze_ocr_cli → OCR Processing
```

**Which project should I use?**

- 📰 **Want to collect Kabardian texts?** → Use this repository (zbze-crawler)
- 🎓 **Want to train OCR models?** → Use [zbze_ocr](https://github.com/zbze-org/zbze_ocr)
- 📦 **Just need the OCR models?** → Use [tesseract-kbd-model](https://github.com/zbze-org/tesseract-kbd-model)
- 🔧 **Need to process scanned documents?** → Use [zbze_ocr_cli](https://github.com/zbze-org/zbze_ocr_cli)

### External Resources

- **[Scrapy](https://scrapy.org/)** - Fast and powerful web crawling framework
- **[TinyDB](https://tinydb.readthedocs.io/)** - Lightweight document-oriented database
- **[Kabardian Language Wikipedia](https://ru.wikipedia.org/wiki/Кабардино-черкесский_язык)** - Language information

### Community

- **[zbze-org](https://github.com/zbze-org)** - Organization supporting Kabardian language digitization
- **[UNESCO Endangered Languages](https://en.wikipedia.org/wiki/Lists_of_endangered_languages)** - List of vulnerable languages

---

<div align="center">

**Made with ❤️ for the Kabardian language community**

[⬆ Back to Top](#zbze-crawler)

</div>

.PHONY: help install install-dev clean lint format crawl-all crawl-apkbr crawl-elgkbr crawl-oshhamaho list-spiders check-data pre-commit

# Default target
help:
	@echo "zbze-crawler - Makefile commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make install          Install production dependencies"
	@echo "  make install-dev      Install development dependencies"
	@echo "  make clean            Clean temporary files and cache"
	@echo "  make lint             Run code linters"
	@echo "  make format           Format code with ruff"
	@echo "  make crawl-all        Run all spiders"
	@echo "  make crawl-apkbr      Run apkbr_ru spider"
	@echo "  make crawl-elgkbr     Run elgkbr_ru spider"
	@echo "  make crawl-oshhamaho  Run oshhamaho spider"
	@echo "  make list-spiders     List all available spiders"
	@echo "  make check-data       Check collected data statistics"
	@echo "  make pre-commit       Install pre-commit hooks"

# Installation
install:
	pip install -r requirements.in

install-dev: install
	pip install -e ".[dev]"

# Cleaning
clean:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type d -name '*.egg-info' -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name '.pytest_cache' -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name '.ruff_cache' -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/
	@echo "Cleaned temporary files and cache"

# Code quality
lint:
	ruff check zbze_scrapy/

format:
	ruff check zbze_scrapy/ --fix
	ruff format zbze_scrapy/

# Crawling commands
crawl-all:
	@echo "Running all spiders..."
	cd zbze_scrapy && scrapy crawl apkbr_ru
	cd zbze_scrapy && scrapy crawl apkbr_ru_feed
	cd zbze_scrapy && scrapy crawl elgkbr_ru
	cd zbze_scrapy && scrapy crawl oshhamaho
	@echo "All spiders completed"

crawl-apkbr:
	cd zbze_scrapy && scrapy crawl apkbr_ru

crawl-apkbr-feed:
	cd zbze_scrapy && scrapy crawl apkbr_ru_feed

crawl-elgkbr:
	cd zbze_scrapy && scrapy crawl elgkbr_ru

crawl-oshhamaho:
	cd zbze_scrapy && scrapy crawl oshhamaho

list-spiders:
	cd zbze_scrapy && scrapy list

# Data management
check-data:
	@echo "Data statistics:"
	@echo ""
	@for dir in data/*/; do \
		if [ -d "$$dir" ]; then \
			echo "Source: $$(basename $$dir)"; \
			if [ -f "$$dir"*.jsonl ]; then \
				echo "  Articles: $$(wc -l < $$dir*.jsonl 2>/dev/null || echo 0)"; \
			fi; \
			if [ -f "$$dir"*.json ]; then \
				echo "  Database: $$dir*.json"; \
			fi; \
			echo "  HTML files: $$(find $$dir -name '*.html' 2>/dev/null | wc -l)"; \
			echo ""; \
		fi; \
	done

# Development tools
pre-commit:
	pre-commit install
	@echo "Pre-commit hooks installed"

pre-commit-run:
	pre-commit run --all-files

# Testing (placeholder for future)
test:
	@echo "No tests defined yet"
	@echo "Add pytest configuration in future releases"

.PHONY: help venv install install-dev clean lint format crawl-all crawl-apkbr crawl-elgkbr crawl-oshhamaho list-spiders check-data pre-commit sync

# Variables
VENV := .venv
UV := uv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
SCRAPY := $(PWD)/$(VENV)/bin/scrapy
RUFF := $(PWD)/$(VENV)/bin/ruff
PRECOMMIT := $(PWD)/$(VENV)/bin/pre-commit

# Default target
help:
	@echo "zbze-crawler - Makefile commands"
	@echo ""
	@echo "Available commands:"
	@echo "  make venv             Create virtual environment with uv"
	@echo "  make install          Install production dependencies"
	@echo "  make install-dev      Install development dependencies"
	@echo "  make sync             Sync dependencies with uv"
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

# Virtual environment
venv:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Creating virtual environment with uv..."; \
		$(UV) venv $(VENV); \
		echo "Virtual environment created at $(VENV)"; \
		echo ""; \
		echo "To activate, run:"; \
		echo "  source $(VENV)/bin/activate"; \
	else \
		echo "Virtual environment already exists at $(VENV)"; \
	fi

# Installation
install: venv
	@echo "Installing dependencies with uv..."
	$(UV) pip install -r requirements.in
	@echo "Dependencies installed!"

install-dev: install
	@echo "Installing development dependencies..."
	$(UV) pip install ruff pre-commit
	@echo "Development dependencies installed!"

sync: venv
	@echo "Syncing dependencies with uv..."
	$(UV) pip sync requirements.in
	@echo "Dependencies synced!"

# Cleaning
clean:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete
	find . -type d -name '*.egg-info' -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name '.pytest_cache' -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name '.ruff_cache' -exec rm -rf {} + 2>/dev/null || true
	rm -rf build/ dist/
	@echo "Cleaned temporary files and cache"

clean-all: clean
	rm -rf $(VENV)
	@echo "Removed virtual environment"

# Code quality
lint:
	@if [ ! -f "$(RUFF)" ]; then \
		echo "Error: ruff not found. Run 'make install-dev' first"; \
		exit 1; \
	fi
	$(RUFF) check zbze_scrapy/

format:
	@if [ ! -f "$(RUFF)" ]; then \
		echo "Error: ruff not found. Run 'make install-dev' first"; \
		exit 1; \
	fi
	$(RUFF) check zbze_scrapy/ --fix
	$(RUFF) format zbze_scrapy/

# Crawling commands
crawl-all:
	@if [ ! -f "$(SCRAPY)" ]; then \
		echo "Error: scrapy not found. Run 'make install' first"; \
		exit 1; \
	fi
	@echo "Running all spiders..."
	cd zbze_scrapy && $(SCRAPY) crawl apkbr_ru
	cd zbze_scrapy && $(SCRAPY) crawl apkbr_ru_feed
	cd zbze_scrapy && $(SCRAPY) crawl elgkbr_ru
	cd zbze_scrapy && $(SCRAPY) crawl oshhamaho
	@echo "All spiders completed"

crawl-apkbr:
	@if [ ! -f "$(SCRAPY)" ]; then echo "Run 'make install' first"; exit 1; fi
	cd zbze_scrapy && $(SCRAPY) crawl apkbr_ru

crawl-apkbr-feed:
	@if [ ! -f "$(SCRAPY)" ]; then echo "Run 'make install' first"; exit 1; fi
	cd zbze_scrapy && $(SCRAPY) crawl apkbr_ru_feed

crawl-elgkbr:
	@if [ ! -f "$(SCRAPY)" ]; then echo "Run 'make install' first"; exit 1; fi
	cd zbze_scrapy && $(SCRAPY) crawl elgkbr_ru

crawl-oshhamaho:
	@if [ ! -f "$(SCRAPY)" ]; then echo "Run 'make install' first"; exit 1; fi
	cd zbze_scrapy && $(SCRAPY) crawl oshhamaho

list-spiders:
	@if [ ! -f "$(SCRAPY)" ]; then echo "Run 'make install' first"; exit 1; fi
	cd zbze_scrapy && $(SCRAPY) list

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
pre-commit: install-dev
	@if [ ! -f "$(PRECOMMIT)" ]; then \
		echo "Error: pre-commit not found. Run 'make install-dev' first"; \
		exit 1; \
	fi
	$(PRECOMMIT) install
	@echo "Pre-commit hooks installed"

pre-commit-run:
	@if [ ! -f "$(PRECOMMIT)" ]; then echo "Run 'make install-dev' first"; exit 1; fi
	$(PRECOMMIT) run --all-files

# Testing (placeholder for future)
test:
	@echo "No tests defined yet"
	@echo "Add pytest configuration in future releases"

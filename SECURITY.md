# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of zbze-crawler seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Where to Report

**Please do not report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to:

- **Email:** a.panagoa@gmail.com
- **Subject:** [SECURITY] zbze-crawler vulnerability report

### What to Include

Please include the following information in your report:

- **Type of issue** (e.g., injection vulnerability, data leakage, authentication bypass)
- **Full paths of source file(s)** related to the manifestation of the issue
- **The location of the affected source code** (tag/branch/commit or direct URL)
- **Any special configuration** required to reproduce the issue
- **Step-by-step instructions** to reproduce the issue
- **Proof-of-concept or exploit code** (if possible)
- **Impact of the issue**, including how an attacker might exploit it

### What to Expect

- **Acknowledgment:** We will acknowledge your email within 48 hours
- **Initial Assessment:** We will provide an initial assessment within 5 business days
- **Updates:** We will keep you informed of the progress towards a fix
- **Resolution:** We will notify you when the issue is fixed
- **Disclosure:** We will coordinate public disclosure with you

## Security Considerations for Contributors

### Scrapy Security Best Practices

When developing spiders, please follow these security guidelines:

1. **Input Validation:**
   - Validate and sanitize all extracted data
   - Be cautious with URLs and external links
   - Don't execute extracted code

2. **Credential Management:**
   - Never hardcode credentials in spider code
   - Use environment variables or secure configuration files
   - Add credential files to `.gitignore`

3. **Data Storage:**
   - Ensure proper file permissions for data directory
   - Don't store sensitive data in plain text
   - Be mindful of copyright and privacy when collecting data

4. **Network Security:**
   - Use HTTPS when available
   - Verify SSL certificates in production
   - Respect robots.txt and rate limits
   - Don't bypass authentication mechanisms

5. **Code Injection Prevention:**
   - Never use `eval()` on extracted data
   - Sanitize data before database insertion
   - Use parameterized queries if using SQL databases

### Example: Secure Spider Code

**Bad Practice:**
```python
# DON'T DO THIS
def parse_item(self, response):
    # Dangerous: executing extracted code
    code = response.css('script::text').get()
    eval(code)  # NEVER DO THIS

    # Dangerous: SQL injection risk
    url = response.url
    query = f"INSERT INTO urls VALUES ('{url}')"  # VULNERABLE
```

**Good Practice:**
```python
# DO THIS INSTEAD
def parse_item(self, response):
    # Safe: just extract and store data
    title = response.css('h1::text').get()
    content = ''.join(response.css('div.content ::text').getall())

    # Safe: use proper database methods
    item = {
        'url': response.url,
        'title': title,
        'content': content,
    }
    self.save_to_db(item)  # Uses upsert with query
    yield item
```

## Known Security Considerations

### 1. HTTP Caching

The project uses HTTP caching to avoid re-downloading content. Cached files are stored locally in:
- `zbze_scrapy/.scrapy/httpcache/`

**Security Implications:**
- Cached responses may contain sensitive data
- Cache directory should have appropriate file permissions
- Consider clearing cache periodically

**Mitigation:**
- Cache directory is in `.gitignore`
- Users should secure their local environment

### 2. Data Storage

Collected data is stored in:
- `data/` directory (JSON Lines and TinyDB files)

**Security Implications:**
- May contain personal data from public sources
- Files are stored unencrypted
- Sensitive information from crawled pages may be stored

**Mitigation:**
- Data directory is in `.gitignore`
- Users are responsible for securing their data
- Follow copyright and privacy guidelines

### 3. Third-Party Dependencies

This project depends on:
- Scrapy
- BeautifulSoup4
- Requests
- TinyDB

**Security Implications:**
- Vulnerabilities in dependencies affect this project

**Mitigation:**
- Keep dependencies updated
- Monitor security advisories
- Use `pip-tools` for reproducible builds

### 4. Web Scraping Legal Considerations

**Important:**
- Always review website terms of service
- Respect robots.txt
- Honor copyright and intellectual property rights
- Only use data for academic/research purposes as stated

## Security Checklist for Contributors

Before submitting code, ensure:

- [ ] No hardcoded credentials or API keys
- [ ] No sensitive data in code or commits
- [ ] Input validation for all extracted data
- [ ] No use of `eval()` or `exec()`
- [ ] Proper error handling (no information leakage)
- [ ] Dependencies are up to date
- [ ] No SQL injection vulnerabilities
- [ ] File paths are validated
- [ ] HTTP caching doesn't expose sensitive data

## Security Updates

Security updates will be:
- Released as patch versions (0.1.x)
- Documented in CHANGELOG.md
- Announced via GitHub releases
- Emailed to reporters

## Disclosure Policy

When we receive a security bug report, we will:

1. Confirm the problem and determine affected versions
2. Audit code to find similar problems
3. Prepare fixes for all supported versions
4. Release patches as soon as possible
5. Publicly disclose the vulnerability

## Comments on This Policy

If you have suggestions on how this process could be improved, please submit a pull request or email a.panagoa@gmail.com.

---

**Last Updated:** January 2025

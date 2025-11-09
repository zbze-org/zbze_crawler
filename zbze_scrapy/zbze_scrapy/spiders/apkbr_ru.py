import os
from urllib.parse import urlparse

from scrapy.exporters import JsonLinesItemExporter
from scrapy.linkextractors import LinkExtractor
from scrapy.spiders import CrawlSpider, Rule
from tinydb import Query, TinyDB


class ApkbrRuSpider(CrawlSpider):
    name = "apkbr_ru"
    allowed_domains = ["apkbr.ru"]
    start_urls = ["https://apkbr.ru/"]

    rules = (
        Rule(LinkExtractor(allow=r"/node"), callback="parse_item", follow=True),
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.dump_dir = f"../data/{self.name}"
        os.makedirs(self.dump_dir, exist_ok=True)

        self.file = open(os.path.join(self.dump_dir, "apkbr_ru.jsonl"), "wb")
        self.exporter = JsonLinesItemExporter(self.file, encoding="utf-8", ensure_ascii=False)
        self.exporter.start_exporting()

        self.db = TinyDB(os.path.join(self.dump_dir, "apkbr_ru.json"))
        self.query = Query()

    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()

    def dump_file(self, response):
        url_path = "__".join(urlparse(response.url).path.split("/"))
        with open(os.path.join(self.dump_dir, f"{url_path}.html"), "wb") as html_file:
            html_file.write(response.body)

    def save_to_db(self, document):
        self.db.upsert(document, self.query.url == document["url"])

    def parse_item(self, response):
        title = response.css("h1.title::text").get()
        publication_date = response.css("div.meta.submitted span::attr(content)").get()
        content = "".join(response.css("div.field-name-body ::text").getall())
        author = response.css("div.field-name-field-author .field-item::text").get()

        item = {
            "url": response.url,
            "title": title.strip() if title else None,
            "publication_date": publication_date.strip() if publication_date else None,
            "content": content.strip() if content else None,
            "author": author.strip() if author else None,
        }

        self.exporter.export_item(item)
        # self.dump_file(response)
        self.save_to_db(item)
        return item


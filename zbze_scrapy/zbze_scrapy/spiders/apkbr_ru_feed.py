import os

from scrapy.exporters import JsonLinesItemExporter
from scrapy.spiders import XMLFeedSpider
from tinydb import TinyDB, Query


class ApkbrRuRssSpider(XMLFeedSpider):
    name = 'apkbr_ru_rss'
    allowed_domains = ['apkbr.ru']
    namespaces = [('dc', 'http://purl.org/dc/elements/1.1/')]

    feed_channel_ids = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    start_urls = [
        f'https://apkbr.ru/taxonomy/term/{cat_id}/feed' for cat_id in feed_channel_ids
    ]
    iterator = 'iternodes'
    itertag = 'item'

    def __init__(self, *args, **kwargs):
        super(ApkbrRuRssSpider, self).__init__(*args, **kwargs)

        self.dump_dir = f'../data/{self.name}'
        os.makedirs(self.dump_dir, exist_ok=True)

        self.file = open(os.path.join(self.dump_dir, 'apkbr_ru_rss.jl'), 'wb')
        self.exporter = JsonLinesItemExporter(self.file, encoding='utf-8', ensure_ascii=False)
        self.exporter.start_exporting()

        self.db = TinyDB(os.path.join(self.dump_dir, 'apkbr_ru_rss.json'))
        self.query = Query()

    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()

    def save_to_db(self, document):
        self.db.upsert(document, self.query.url == document['url'])

    def parse_node(self, response, node):
        title = node.xpath('title/text()').get().strip()
        link = node.xpath('link/text()').get()
        description = node.xpath('description//text()').get().strip()

        pub_date = node.xpath('pubDate/text()').get()
        author = node.xpath('dc:creator/text()', namespaces=self.namespaces).get()

        item = {
            'title': title,
            'url': link,
            'description': description,
            'pub_date': pub_date,
            'author': author,
        }

        self.exporter.export_item(item)
        # self.dump_file(response)
        self.save_to_db(item)
        return item

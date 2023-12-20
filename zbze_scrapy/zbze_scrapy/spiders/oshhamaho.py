import os
import re

import scrapy


class OshhamahoSpider(scrapy.Spider):
    """
    scrapy crawl oshhamaho -a start_year=2007 -a end_year=2023
    """
    name = 'oshhamaho'
    base_url = 'https://smikbr.ru/'
    url_template = 'https://smikbr.ru/oshhamaho{year}'

    def __init__(self, start_year, end_year, *args, **kwargs):
        super(OshhamahoSpider, self).__init__(*args, **kwargs)
        self.data_dir = f'../data/{self.name}'
        os.makedirs(self.data_dir, exist_ok=True)

        self.start_year = int(start_year)
        self.end_year = int(end_year)

    def start_requests(self):
        for year in range(self.start_year, self.end_year + 1):
            yield scrapy.Request(self.url_template.format(year=year))

    def parse(self, response, **kwargs):
        links = response.css('a::attr(href)').getall()

        # /arhiv/2007/pressa/oshamaho/03-04-2007.pdf
        # /arhiv/2020/pressa/oshamaho/01.2020.pdf
        pattern = r'/arhiv/\d{4}/pressa/oshamaho/.*.pdf'
        pdf_links = [link for link in links if re.match(pattern, link)]

        for link in pdf_links:
            yield scrapy.Request(response.urljoin(link), self.save_pdf)

    def save_pdf(self, response):
        filename = response.url.split('/')[-1]
        with open(os.path.join(self.data_dir, filename), 'wb') as pdf_file:
            pdf_file.write(response.body)

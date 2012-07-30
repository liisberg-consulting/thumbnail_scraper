Thumbnail Scraper
============

detect, fetch and generate a thumbnail for any url

Basic usage
-------------
```ruby
require 'thumbnail_scraper'

include ThumbnailScraper
scraper = ThumbnailScraper.new
image = scraper.image_to_thumbnail_url("http://www.monibuds.com/")
thumbnail_url = image.url
```

ThumbnailScraper#image_to_thumbnail_url method returns Image object, which contains its size and url.

Suggested usage
---------------

We encourage you to use it with delayed_job as jobs queue and dragonfly as image storage tool.
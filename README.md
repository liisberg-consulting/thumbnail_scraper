Thumbnail Scraper
============

detect, fetch and generate a thumbnail for any url

Basic usage
-------------
```ruby
include ThumbnailScraper
scraper = ThumbnailScraper.new
image = scraper.image_to_thumbnail_url("http://www.monibuds.com/")
thumbnail_url = image.url
```

ThumbnailScraper#image_to_thumbnail_url method returns Image object, which contains its size and url.
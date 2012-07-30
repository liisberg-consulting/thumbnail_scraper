require 'thumbnail_scraper/with_smart_url'
require 'fastimage'

module ThumbnailScraper
  class Image
    include WithSmartUrl

    def initialize(url)
      self.url = url
    end

    def size
      @size ||= ::FastImage.size(url.to_s)
    end

    def width
      size[0]
    end

    def height
      size[1]
    end

    def area
      width * height
    end
  end
end

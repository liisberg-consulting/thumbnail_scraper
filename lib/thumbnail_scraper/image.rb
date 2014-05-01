require 'thumbnail_scraper/with_smart_url'
require 'fastimage'

module ThumbnailScraper
  class Image
    include WithSmartUrl

    def initialize(url)
      self.url = url
    end

    def exists?
      size ? true : false
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

    def valid?
      width >= 50 && height >= 50 && width.to_f / height.to_f <= 3 && height.to_f / width.to_f <= 3
    end
  end
end

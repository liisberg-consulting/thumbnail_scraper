require 'thumbnail_fu/with_smart_url'
require 'fastimage'

module ThumbnailFu
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

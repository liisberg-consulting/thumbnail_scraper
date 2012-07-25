require 'uri'

module ThumbnailFu
  module WithSmartUrl
    def url=(value)
      if value.is_a?(URI)
        @url = value
      else
        @url = URI.parse(value)
      end
    end

    def url
      @url
    end
  end
end

require 'thumbnail_fu/webpage'
require 'httpclient'

module ThumbnailFu
  class HttpReceiver
    attr_accessor :http_client

    def initialize
      @http_client = ::HTTPClient.new
    end

    def receive_webpage(url)
      content = http_client.get_content(url)
      Webpage.new(url, content)
    end
  end
end

require 'thumbnail_scraper/with_smart_url'
require 'nokogiri'

module ThumbnailScraper
  class Webpage
    attr_accessor :body

    include WithSmartUrl

    def initialize(url, body)
      self.url = url
      self.body = body
    end

    def document
      Nokogiri::HTML::Document.parse(body)
    end

    def image_url(image_path)
      if image_path.start_with?("http://") || image_path.start_with?("https://")
        image_url = URI(image_path)
      elsif image_path.start_with?("//")
        image_url = URI(image_path)
        image_url.scheme = url.scheme
      else
        image_url = URI(url.to_s)
        if Pathname.new(image_path).absolute?
          image_url.path = image_path
        else
          image_url.path = File.expand_path(File.join(File.dirname(url.path), image_path))
        end
      end
      image_url
    end

    def open_graph_image_url
      return @open_graph_image_url if defined?(@open_graph_image_url)
      elements = document.xpath("//meta[@property='og:image']/@content")
      return nil if elements.empty?
      image_path = elements.first.value
      @open_graph_image_url = image_url(image_path)
    end

    def has_open_graph_image?
      !open_graph_image_url.nil?
    end

    def linked_image_url
      return @linked_image_url if defined?(@linked_image_url)
      elements = document.xpath("//link[@rel='img_src']/@href")
      return nil if elements.empty?
      image_path = elements.first.value
      @linked_image_url = image_url(image_path)
    end

    def has_linked_image?
      !linked_image_url.nil?
    end

    def attached_images_urls
      elements = document.xpath("//img/@src")
      elements.map{|element| image_url(element.value)}
    end
  end
end

require "thumbnail_scraper/version"
require 'thumbnail_scraper/image'
require 'thumbnail_scraper/http_receiver'
require 'thumbnail_scraper/no_valid_thumbnail'

module ThumbnailScraper
  class ThumbnailScraper
    attr_accessor :http_receiver

    def initialize(receiver=HttpReceiver.new)
      @http_receiver = receiver
    end

    def create_image(url)
      Image.new(url)
    end

    def image_to_thumbnail_for_url(url)
      webpage = http_receiver.receive_webpage(url)
      if webpage.has_open_graph_image?
        image = create_image(webpage.open_graph_image_url)
      elsif webpage.has_linked_image?
        image = create_image(webpage.linked_image_url)
      else
        image = select_best_possible_image_to_scrap(webpage.attached_images_urls)
      end
      image
    end

    def select_best_possible_image_to_scrap(images_urls)
      images = images_urls.map{|image_url| create_image(image_url)}
      valid_images = select_valid_images(images)
      raise NoValidThumbnail.new if valid_images.empty?
      valid_images.max{|a, b| a.area <=> b.area}
    end

    def select_valid_images(images)
      images.select(&:exists?).select(&:valid?)
    end
  end
end

require "thumbnail_fu/version"
require 'thumbnail_fu/image'
require 'thumbnail_fu/http_receiver'

module ThumbnailFu
  class ThumbnailFu
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
      return nil if valid_images.empty?
      valid_images.max{|a, b| a.area <=> b.area}
    end

    def select_valid_images(images)
      images.select{|image| image_is_valid?(image)}
    end

    def image_is_valid?(image)
      image.width >= 50 && image.height >= 50 && image.width.to_f / image.height.to_f <= 3 && image.height.to_f / image.width.to_f <= 3
    end
  end
end

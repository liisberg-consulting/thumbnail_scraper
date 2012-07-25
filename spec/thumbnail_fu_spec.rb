require 'thumbnail_fu_helper'
require 'thumbnail_fu'

describe ThumbnailFu::ThumbnailFu do
  before :each do
    @thumbnail_scraper = ThumbnailFu::ThumbnailFu.new
  end

  context "for page with og:image" do
    before :each do
      stub_request(:get, "www.example.com/og_image.html").to_return(:body => asset_file("og_image.html"))
      stub_request(:get, "www.example.com/images/kitty.jpg").to_return(:body => asset_file(File.join("images", "kitty.jpg")))
    end

    describe "#image_to_thumbnail_for_url" do
      it "should be found og:image" do
        image_to_thumbnail = @thumbnail_scraper.image_to_thumbnail_for_url("http://www.example.com/og_image.html")
        image_to_thumbnail.url.to_s.should == "http://www.example.com/images/kitty.jpg"
      end
    end
  end

  context "for page with link img_src" do
    before :each do
      stub_request(:get, "www.example.com/img_src.html").to_return(:body => asset_file("img_src.html"))
      stub_request(:get, "www.example.com/images/kitty.jpg").to_return(:body => asset_file(File.join("images", "kitty.jpg")))
    end

    describe "#image_to_thumbnail_for_url" do
      it "should be found link img_src" do
        image_to_thumbnail = @thumbnail_scraper.image_to_thumbnail_for_url("http://www.example.com/img_src.html")
        image_to_thumbnail.url.to_s.should == "http://www.example.com/images/kitty.jpg"
      end
    end
  end

  context "for page with images" do
    before :each do
      stub_request(:get, "www.example.com/images.html").to_return(:body => asset_file("images.html"))
      stub_request(:get, "www.example.com/images/kitty.jpg").to_return(:body => asset_file(File.join("images", "kitty.jpg")))
      stub_request(:get, "www.example.com/images/biggest.jpg").to_return(:body => asset_file(File.join("images", "biggest.jpg")))
      stub_request(:get, "www.example.com/images/subcatalog/smallest.jpg").to_return(:body => asset_file(File.join("images", "subcatalog", "smallest.jpg")))
    end

    describe "#image_to_thumbnail_for_url" do
      it "should be biggest image from page" do
        image_to_thumbnail = @thumbnail_scraper.image_to_thumbnail_for_url("http://www.example.com/images.html")
        image_to_thumbnail.url.to_s.should == "http://www.example.com/images/biggest.jpg"
      end
    end
  end
end

require 'thumbnail_scraper_helper'
require 'thumbnail_scraper/webpage'

module ThumbnailScraper
  describe Webpage do
    before :each do
      @url = "http://www.example.com/site/site.html"
      @webpage = Webpage.new(@url, "")
    end

    describe "#image_url" do
      context "for relative path" do
        it "should be with absolute path based on page url and image relative path" do
          @webpage.image_url("images/kitty.jpg").path.should == "/site/images/kitty.jpg"
        end

        it "should have same host as page" do
          @webpage.image_url("images/kitty.jpg").host.should == "www.example.com"
        end
      end

      context "for absolute path" do
        it "should be with absolute path based on image path" do
          @webpage.image_url("/images/kitty.jpg").path.should == "/images/kitty.jpg"
        end

        it "should have same host as page" do
          @webpage.image_url("/images/kitty.jpg").host.should == "www.example.com"
        end
      end

      context "for full uri" do
        it "should be with absolute path based on image path" do
          @webpage.image_url("http://outersite.com/images/kitty.jpg").path.should == "/images/kitty.jpg"
        end

        it "should have same host as page" do
          @webpage.image_url("http://outersite.com/images/kitty.jpg").host.should == "outersite.com"
        end

        context "for https address" do
          it "should have image's host" do
            @webpage.image_url("https://outersite.com/images/kitty.jpg").host.should == "outersite.com"
          end
        end

        context "for shortcut address" do
          it "should have image's host" do
            @webpage.image_url("//outersite.com/images/kitty.jpg").host.should == "outersite.com"
          end

          it "should have same scheme as page" do
            @webpage.image_url("//outersite.com/images/kitty.jpg").scheme.should == "http"
          end
        end
      end
    end

    describe "#open_graph_image_url" do
      context "for document with og:image" do
        before :each do
          @webpage.body = File.read(asset_file_path("og_image.html"))
          @webpage.stub!(:image_url).and_return(:image_url)
        end

        it "should use #image_url to construct final image url" do
          @webpage.should_receive(:image_url).with("images/kitty.jpg").and_return(:image_url)
          @webpage.open_graph_image_url
        end

        it "should return url constructed by image_url" do
          @webpage.open_graph_image_url.should == :image_url
        end
      end

      context "for document without og:image" do
        before :each do
          @webpage.body = File.read(asset_file_path("img_src.html"))
        end

        it "should be nil" do
          @webpage.open_graph_image_url.should be_nil
        end
      end
    end

    describe "#has_open_graph_image" do
      context "for nil #open_graph_image_url" do
        before :each do
          @webpage.stub!(:open_graph_image_url).and_return(nil)
        end

        it "should be false" do
          @webpage.has_open_graph_image?.should be_false
        end
      end

      context "for not nil #open_graph_image_url" do
        before :each do
          @webpage.stub!(:open_graph_image_url).and_return(:image_url)
        end

        it "should be true" do
          @webpage.has_open_graph_image?.should be_true
        end
      end
    end

    describe "#linked_image_url" do
      context "for document with link img_src" do
        before :each do
          @webpage.body = File.read(asset_file_path("img_src.html"))
          @webpage.stub!(:image_url).and_return(:image_url)
        end

        it "should use #image_url to construct final image url" do
          @webpage.should_receive(:image_url).with("images/kitty.jpg").and_return(:image_url)
          @webpage.linked_image_url
        end

        it "should return url constructed by image_url" do
          @webpage.linked_image_url.should == :image_url
        end
      end

      context "for document without link img_src" do
        before :each do
          @webpage.body = File.read(asset_file_path("og_image.html"))
        end

        it "should be nil" do
          @webpage.linked_image_url.should be_nil
        end
      end
    end

    describe "#has_linked_image" do
      context "for nil #linked_image_url" do
        before :each do
          @webpage.stub!(:linked_image_url).and_return(nil)
        end

        it "should be false" do
          @webpage.has_linked_image?.should be_false
        end
      end

      context "for not nil #linked_image_url" do
        before :each do
          @webpage.stub!(:linked_image_url).and_return(:image_url)
        end

        it "should be true" do
          @webpage.has_linked_image?.should be_true
        end
      end
    end

    describe "#attached_images_urls" do
      context "with images in body" do
        before :each do
          @webpage.body = File.read(asset_file_path("images.html"))
          @webpage.stub!(:image_url).with("/images/subcatalog/smallest.jpg").and_return(:smallest_url)
          @webpage.stub!(:image_url).with("/images/kitty.jpg").and_return(:kitty_url)
          @webpage.stub!(:image_url).with("images/biggest.jpg").and_return(:biggest_url)
        end

        it "should return all urls of found images" do
          urls = @webpage.attached_images_urls
          urls.should include(:smallest_url)
          urls.should include(:kitty_url)
          urls.should include(:biggest_url)
        end
      end
    end
  end
end

require 'thumbnail_fu_helper'
require 'thumbnail_fu'

module ThumbnailFu
  describe ThumbnailFu do
    before :each do
      @http_receiver = mock("http receiver mock")
      @thumbnail_fu = ThumbnailFu.new(@http_receiver)
    end

    describe "#image_to_thumbnail_for_url" do
      context "for webpage with open graph image" do
        before :each do
          @page_url = "http://www.example.com/index.html"
          @image_url = "http://www.example.com/images/image.png"
          @webpage = mock("webpage")
          @image = mock("image")
          @webpage.stub!(:open_graph_image_url).and_return(@image_url)
          @thumbnail_fu.stub!(:create_image).with(@image_url).and_return(@image)
          @webpage.stub!(:has_open_graph_image?).and_return(true)
          @http_receiver.stub!(:receive_webpage).with(@page_url).and_return(@webpage)
        end

        it "should return image" do
          @thumbnail_fu.image_to_thumbnail_for_url(@page_url).should == @image
        end
      end

      context "for webpage with link img_src" do
        before :each do
          @page_url = "http://www.example.com/index.html"
          @image_url = "http://www.example.com/images/image.png"
          @webpage = mock("webpage")
          @image = mock("image")
          @webpage.stub!(:has_open_graph_image?).and_return(false)
          @webpage.stub!(:linked_image_url).and_return(@image_url)
          @webpage.stub!(:has_linked_image?).and_return(true)
          @thumbnail_fu.stub!(:create_image).with(@image_url).and_return(@image)
          @http_receiver.stub!(:receive_webpage).with(@page_url).and_return(@webpage)
        end

        it "should return image" do
          @thumbnail_fu.image_to_thumbnail_for_url(@page_url).should == @image
        end
      end

      context "for webpage with only images" do
        before :each do
          @page_url = "http://www.example.com/index.html"
          @webpage = mock("webpage")
          @webpage.stub!(:has_open_graph_image?).and_return(false)
          @webpage.stub!(:has_linked_image?).and_return(false)
          @webpage.stub!(:attached_images_urls).and_return([:first, :second, :third])
          @thumbnail_fu.stub!(:create_image).and_return(:image)
          @http_receiver.stub!(:receive_webpage).with(@page_url).and_return(@webpage)
          @http_receiver.stub!(:receive_image).with(:image).and_return(:image_content)
          @thumbnail_fu.stub!(:select_best_possible_image_to_scrap).and_return(:image)
        end

        it "should use Website#attached_images_urls to get all images" do
          @webpage.should_receive(:attached_images_urls).and_return([:first, :second, :third])
          @thumbnail_fu.image_to_thumbnail_for_url(@page_url)
        end

        it "should select_best_possible_image_to_scrap" do
          @thumbnail_fu.should_receive(:select_best_possible_image_to_scrap).with([:first, :second, :third]).and_return(:image)
          @thumbnail_fu.image_to_thumbnail_for_url(@page_url)
        end
      end
    end

    describe "#select_best_possible_image_to_scrap" do
      before :each do
        @image1 = mock("image")
        @image1.stub!(:area).and_return(250)
        @image2 = mock("image")
        @image2.stub!(:area).and_return(1000)
        @images_urls = [:first, :second]
        @thumbnail_fu.stub!(:create_image).with(:first).and_return(@image1)
        @thumbnail_fu.stub!(:create_image).with(:second).and_return(@image2)
        @thumbnail_fu.stub!(:select_valid_images).with([@image1, @image2]).and_return([@image1, @image2])
      end

      it "should create all images" do
        @thumbnail_fu.should_receive(:create_image).with(:first).and_return(@image1)
        @thumbnail_fu.should_receive(:create_image).with(:second).and_return(@image2)
        @thumbnail_fu.select_best_possible_image_to_scrap(@images_urls)
      end

      it "should filter out invalid images" do
        @thumbnail_fu.should_receive(:select_valid_images).with([@image1, @image2]).and_return([@image1, @image2])
        @thumbnail_fu.select_best_possible_image_to_scrap(@images_urls)
      end

      it "should be biggest (by area) image of valid ones" do
        @thumbnail_fu.select_best_possible_image_to_scrap(@images_urls).should == @image2
      end

      context "for all invalid images" do
        it "should be nil" do
          @thumbnail_fu.should_receive(:select_valid_images).and_return([])
          @thumbnail_fu.select_best_possible_image_to_scrap(@images_urls).should be_nil
        end
      end
    end

    describe "#select_valid_images" do
      before :each do
        @image1 = mock("image")
        @image2 = mock("image")
        @thumbnail_fu.stub!(:image_is_valid?).with(@image1).and_return(true)
        @thumbnail_fu.stub!(:image_is_valid?).with(@image2).and_return(false)
      end

      it "should use #image_is_valid? to validate image" do
        @thumbnail_fu.stub!(:image_is_valid?).with(@image1).and_return(true)
        @thumbnail_fu.stub!(:image_is_valid?).with(@image2).and_return(false)
        @thumbnail_fu.select_valid_images([@image1, @image2])
      end

      it "should select only valid images" do
        @thumbnail_fu.select_valid_images([@image1, @image2]).should == [@image1]
      end
    end

    describe "#image_is_valid?" do
      before :each do
        @image = mock("image")
        @image.stub!(:width).and_return(100)
        @image.stub!(:height).and_return(100)
      end

      context "for small image width" do
        before :each do
          @image.stub!(:width).and_return(49)
        end

        it "should be false" do
          @thumbnail_fu.image_is_valid?(@image).should be_false
        end
      end

      context "for small image height" do
        before :each do
          @image.stub!(:height).and_return(49)
        end

        it "should be false" do
          @thumbnail_fu.image_is_valid?(@image).should be_false
        end
      end

      context "width to height ratio bigger than 3:1" do
        before :each do
          @image.stub!(:width).and_return(301)
          @image.stub!(:height).and_return(100)
        end

        it "should be false" do
          @thumbnail_fu.image_is_valid?(@image).should be_false
        end
      end

      context "height to width ratio bigger than 3:1" do
        before :each do
          @image.stub!(:width).and_return(100)
          @image.stub!(:height).and_return(301)
        end

        it "should be false" do
          @thumbnail_fu.image_is_valid?(@image).should be_false
        end
      end

      context "otherwise" do
        it "should be true" do
          @thumbnail_fu.image_is_valid?(@image).should be_true
        end
      end
    end
  end
end

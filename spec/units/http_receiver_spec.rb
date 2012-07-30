require 'thumbnail_scraper_helper'
require 'thumbnail_scraper/http_receiver'

module ThumbnailScraper
  describe HttpReceiver do
    before :each do
      @http_receiver = HttpReceiver.new
    end

    describe "#receive_webpage" do
      before :each do
        stub_request(:get, "www.example.com/index.html").to_return(:body => "<p>I'm a webpage</p>")
      end

      it "should set Webpage#body" do
        @http_receiver.receive_webpage("http://www.example.com/index.html").body == "<p>I'm a webpage</p>"
      end

      it "should set Webpage#uri" do
        @http_receiver.receive_webpage("http://www.example.com/index.html").url.should == URI.parse("http://www.example.com/index.html")
      end
    end
  end
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/thumbnail_scraper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jan Filipowski"]
  gem.email         = ["jachuf@gmail.com"]
  gem.description   = %q{detect, fetch and generate a thumbnail for any url and store it on s3}
  gem.summary       = %q{detect, fetch and generate a thumbnail for any url and store it on s3}
  gem.homepage      = ""

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
  gem.add_runtime_dependency "httpclient"
  gem.add_runtime_dependency "fastimage"
  gem.add_runtime_dependency "nokogiri"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "thumbnail_scraper"
  gem.require_paths = ["lib"]
  gem.version       = ThumbnailScraper::VERSION
end

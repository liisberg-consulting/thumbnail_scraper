require 'webmock/rspec'

def asset_file_path(name)
  File.join("spec", "sample_pages", name)
end

def asset_file(name)
  path = asset_file_path(name)
  File.new(path)
end


#!/usr/bin/env ruby
require "json"
require "net/http"
require "uri"
require "open-uri"
require "zip"
require "pathname"
require "fileutils"
require "pp"

APP_ROOT = File.expand_path("../../", __FILE__)
TMP_DIR = File.join(APP_ROOT, "tmp")

DEST_DIR = File.join(APP_ROOT, "app/assets/stylesheets/nextbbs/bulma")

puts "APP_ROOT: #{APP_ROOT}"

OWNER = "jgthms"
REPO = "bulma"
api_url = "https://api.github.com/repos/#{OWNER}/#{REPO}/releases"

response = Net::HTTP.get_response(URI.parse(api_url))

case response
when Net::HTTPSuccess
  result = JSON.parse(response.body)
else
  pp response
  exit
end

# Select assets
choice_assets = false
result.each do |assets|
  unless assets["draft"] || assets["prerelease"]
    choice_assets = assets
    break
  end
end

# pp choice_assets

# Select asset
target = false
choice_assets["assets"].each do |asset|
  target = {
    url: asset["url"],
    filename: asset["name"],
  }
  break
end

# download file
# pp target
tmp_file = File.join(TMP_DIR, target[:filename])
open(tmp_file, "w+b") do |out|
  open(target[:url], "Accept" => "application/octet-stream") do |f|
    out.write(f.read)
  end
end

# extract file
FileUtils.rm_r(DEST_DIR)
FileUtils.mkdir(DEST_DIR)
Zip::File.open(tmp_file) do |zip|
  zip.each do |entry|
    paths = entry.name.split(File::SEPARATOR)
    if paths.length > 1
      dest = File.join(DEST_DIR, paths[1..-1])
      puts "#{entry.name} => #{dest}"
      zip.extract(entry, dest) { true }
    else
      puts "#{entry.name} => skip"
    end
  end
end

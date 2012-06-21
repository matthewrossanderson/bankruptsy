require 'sinatra'
require 'builder'
require 'rss'
require './legalscraper.rb'

get '/' do
  "Hello, world!"
end
get '/rss', :provides => ['rss', 'atom', 'xml'] do
	scraper = Scrape.new
	cases = scraper.currentcases	
	content_type 'application/rss+xml'
	
	@rss = RSS::Maker.make("atom") do |maker|
	  maker.channel.author = "Author"
	  maker.channel.updated = Time.now.to_s
	  maker.channel.about = "bankruptsy"
	  maker.channel.title = "Example Feed"
	  cases.each do |c|
		  maker.items.new_item do |item|
			item.link = c[:url]
			item.title = c[:casename]
			item.updated = Time.now.to_s
		  end
		end
	end
end


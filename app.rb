require 'sinatra'
require 'builder'
require 'rss'
require 'rack/cache'
require './legalscraper'

use Rack::Cache,
  :metastore  => 'heap:/',
  :entitystore => 'heap:/'

get '/' do
  cache_control :public, :must_revalidate, :max_age => 60
  "Hello, world!"
end
get '/rss', :provides => ['rss', 'atom', 'xml'] do
	cache_control :public, :must_revalidate, :max_age => 60
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
	erb :feed
end


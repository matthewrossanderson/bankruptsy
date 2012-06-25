require 'sinatra'
require './legalscraper'
require 'rss'
require 'rack/cache'

use Rack::Cache,
  :metastore  => 'heap:/',
  :entitystore => 'heap:/'
  
configure :production do
  require 'newrelic_rpm'
end

get '/' do
  cache_control :public, :must_revalidate, :max_age => 60
  "Hello, world!"
end

get '/rss', :provides => ['rss', 'atom', 'xml'] do
	cache_control :public, :must_revalidate, :max_age => 60
	scraper = Scrape.new
	cases = scraper.currentcases	
	#content_type 'application/rss+xml'
	
	@rss = RSS::Maker.make("atom") do |maker|
	  maker.channel.author = "manderson"
	  maker.channel.updated = Time.now.to_s
	  maker.channel.about = "http://electric-frost-5456.herokuapp.com/rss"
	  maker.channel.title = "Bankruptsy Feed"
	  cases.each do |c|
		  maker.items.new_item do |item|
			item.id = "#{Time.now.to_f}"
			item.link = c[:url]
			item.title = c[:casename]
			item.updated = Time.now.to_s
			item.description = c[:casename]
		  end
		end
	end
	erb :feed
end


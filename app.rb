require 'sinatra'
require 'builder'

get '/' do
  "Hello, world!"
end
get '/rss', :provides => ['rss', 'atom', 'xml'] do
	@cases = Array["test", "test2", "test3"]


	#content_type 'application/rss+xml'
	builder :feed
end

def to_xs_date_time(time)
  DateTime.parse(time.to_s).strftime('%Y-%m-%dT%H:%M:%S%z').insert(-3, ':')
end
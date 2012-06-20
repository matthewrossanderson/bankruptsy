require 'httparty'
require 'pp'
require 'nokogiri'
require 'rubygems'
require 'mechanize'

class DBProxy
	include HTTParty
	http_proxy 'surf-proxy.intranet.db.com', 8080
end

baseuri = 'http://www.kccllc.net/default.asp'
options = {
	:ddlSort => 'RecentFile',
	:hfLastSort=>'CaseName',
	:hfCurrPage=>0
}

response = DBProxy.post( baseuri, :body => options )
doc = Nokogiri.HTML(response)
currentcases = Array.new

doc.css('#divContent table tr td table').each do |table|
	if /tblCase\d/.match(table['id'])
		table.css('tr td a').each do |a|
			if /http:\/\/.*/.match(a['href'])
				link = a['href']
			else 
				link = 'http://www.kccllc.net/' + a['href']
			end
			puts link
			currentcases.push a.text + " | " + link +  "\n"
		end
	end
end

#pp currentcases.join
File.open('output.csv', 'w') {|f| f.write(currentcases.join) }

agent = Mechanize.new do |a|
  a.set_proxy('surf-proxy.intranet.db.com', 8080)
  a.user_agent_alias = "Windows IE 8"
end

page = agent.get('http://www.kccllc.net/afa')
continueform = page.form('frmDisclaimer')
page = agent.submit(continueform)
page.body


class Scrape

	require 'httparty'
	require 'pp'
	require 'nokogiri'
	require 'rubygems'
	require 'mechanize'

	class DBProxy
		include HTTParty
		http_proxy 'surf-proxy.intranet.db.com', 8080
	end
	
	def currentcases
		baseuri = 'http://www.kccllc.net/default.asp'
		options = {
			:ddlSort => 'RecentFile',
			:hfLastSort=>'CaseName',
			:hfCurrPage=>0
		}

		response = HTTParty.post( baseuri, :body => options )
		doc = Nokogiri.HTML(response)
		cases = Array.new

		doc.css('#divContent table tr td table').each do |table|
			if /tblCase\d/.match(table['id'])
				table.css('tr td a').each do |a|
					if /http:\/\/.*/.match(a['href'])
						link = a['href']
					else 
						link = 'http://www.kccllc.net/' + a['href']
					end
					#/[0-9]*\-[0-9]*\s\|\s/  Regex for matching the casenumber
					cases.push Hash[:casename => a.text, :url => link]
				end
			end
		end
		cases
		#cases.each { |c| puts c[:url] + "  "  + c[:casename] }
		#File.open('output.csv', 'w') {|f| f.write(currentcases.join) }
	end
	
	def case(url)
		if /http:\/\/www\.kccllc\.net\/\S*/.match(url)
			agent = Mechanize.new do |a|
				a.set_proxy('surf-proxy.intranet.db.com', 8080)
				a.user_agent_alias = "Windows IE 8"
			end
			page = agent.get(url)
			continueform = page.form('frmDisclaimer')
			page = agent.submit(continueform)
			page.body
		else
			"External website: <a href='#{url}'>#{url}</a>"
		end
	end
end


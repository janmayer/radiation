# encoding: utf-8
require 'csv'
require 'plusminus'

require 'open-uri'
require 'open-uri/cached'
require 'tmpdir'


class Radiation::Source
	def datasource_nucleideorg(nuclide)
		OpenURI::Cache.cache_path = Dir.tmpdir
		uri = open("http://www.nucleide.org/DDEP_WG/Nuclides/#{nuclide}.lara.txt").readlines
		start = 0
		uri.each_with_index do |line, lineno|
			if line.start_with?("------")
				start = lineno + 2
				break
			end
		end
		return [] if start == 0 or uri.count < start
		data = uri[start...-1].collect{|line| CSV.parse(line,  {col_sep: ' ; '}).first}
		data.select!{|row| row[4] == "g"}
		data.collect!{|row| {:energy => row[0].to_f.pm(row[1].to_f), :intensity => row[2].to_f.pm(row[3].to_f)} }
	end
end
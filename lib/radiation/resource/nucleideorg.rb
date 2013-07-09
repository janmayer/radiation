# encoding: utf-8
require 'plusminus'
require 'open-uri'
require 'open-uri/cached'
require 'tmpdir'


module Radiation::Resource
	class Nucleideorg < Base
		
		def fetch(nuclide)
			@nuclide = nuclide
			@nuclide = "Ra-226D" if @nuclide == "Ra-226" #Ra-226 in equilibrium with daughters
			begin
				@data[:nuclide] = @nuclide.to_s
				OpenURI::Cache.cache_path = "#{Dir.tmpdir}/radiation/"
				uri = open("http://www.nucleide.org/DDEP_WG/Nuclides/#{@nuclide}.lara.txt").readlines
				start = 0
				uri.each_with_index do |line, lineno|
					if line.start_with?("------")
						start = lineno + 2
						break
					end
				end
				return @data[:transitions] = [] if start == 0 or uri.count < start
				@data[:transitions] = uri[start...-1].collect{|line| line.split(' ; ')}.select!{|row| row[4] == "g"}.collect do |row|
				 {:energy => row[0].to_f.pm(row[1].to_f), :intensity => row[2].to_f.pm(row[3].to_f)} 
				end
			rescue
				raise "No Data for #{@nuclide}"
			end
			self
		end

	end
end
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

				@data[:reference] = "A. Pluquet et al. (2013). Recommended data for #{@nuclide} by the Decay Data Evaluation Project working group. Decay Data Evaluation Project, Laboratoire National Henri Becquerel, C.E. Saclay. Retrieved from http://www.nucleide.org/DDEP_WG/Nuclides/#{@nuclide}.lara.txt"

				OpenURI::Cache.cache_path = "#{Dir.tmpdir}/radiation/"
				uri = open("http://www.nucleide.org/DDEP_WG/Nuclides/#{@nuclide}.lara.txt").readlines
				start = 0
				uri.each_with_index do |line, lineno|
					if line.start_with?("Half-life (s)")
						row = line.split(' ; ')
						@data[:halflife] = row[1].to_f.pm(row[2].to_f)
					end
					if line.start_with?("------")
						start = lineno + 2
						break
					end
				end
				return @data[:transitions] = [] if start == 0 or uri.count < start
				@data[:transitions] = uri[start...-1].collect{|line| line.split(' ; ')}.select!{|row| row[4] == "g"}.collect do |row|
					# Intensities in DDEP are % based
					{:energy => row[0].to_f.pm(row[1].to_f), :intensity => (row[2].to_f/100).pm(row[3].to_f/100)}
				end
			rescue
				raise "No Data for #{@nuclide}"
			end
			self
		end

	end
end
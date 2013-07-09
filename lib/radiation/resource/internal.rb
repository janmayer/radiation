# encoding: utf-8
require 'csv'

module Radiation::Resource
	class Internal < Base

		def fetch(nuclide)
			@nuclide = nuclide
			begin
				path = File.join(File.dirname(__FILE__), "../../../data")
				@data[:nuclide] = @nuclide.to_s
				@data[:transitions] = CSV.read("#{path}/#{@nuclide}.csv",  {col_sep: ';', converters: :numeric}).collect{|row| {:energy => row[0].pm(0), :intensity => row[1].pm(row[2])} }
			rescue
				raise "No Data for #{nuclide}"
			end
			self
		end
		
	end
end
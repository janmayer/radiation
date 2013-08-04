# encoding: utf-8
require 'csv'

module Radiation::Resource
	class Internal < Base
		# FIXME: Better path creation
		PATH = File.join(File.dirname(__FILE__), "../../../data")
		
		def fetch(nuclide)
			@nuclide = nuclide
			begin
				@data[:nuclide] = @nuclide.to_s
				@data[:transitions] = load_data(@nuclide).collect{|row| {:energy => row[0].pm(0), :intensity => row[1].pm(row[2])} }
			rescue
				raise "No Data for #{nuclide}"
			end
			self
		end

		private
		def load_data(nuclide)
			CSV.read("#{PATH}/#{nuclide}.csv",  {col_sep: ';', converters: :numeric})
		end
	
	end
end
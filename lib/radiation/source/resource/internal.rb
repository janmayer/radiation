# encoding: utf-8
require 'csv'

class Radiation::Source
	class Resource
		private
		def datasource_internal(nuclide)
			begin
				path = File.join(File.dirname(__FILE__), "../../../../data")
				@data[:nuclide] = nuclide.to_s
				@data[:lines] = CSV.read("#{path}/#{nuclide}.csv",  {col_sep: ';', converters: :numeric}).collect{|row| {:energy => row[0].pm(0), :intensity => row[1].pm(row[2])} }
			rescue
				raise "No Data for #{nuclide}"
			end
		end
	end
end
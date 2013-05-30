# encoding: utf-8
require 'csv'

class Radiation::Source
	def datasource_internal(nuclide)
		return CSV.read("data/#{nuclide}.csv",  {col_sep: ';', converters: :numeric}).collect{|row| {:energy => row[0].pm(0), :intensity => row[1].pm(row[2])} }
	end
end
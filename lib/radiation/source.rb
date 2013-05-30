# encoding: utf-8
require 'radiation/source/internal'
require 'radiation/source/nucleideorg'

class Radiation::Source
	attr_accessor :nuclide, :intensities

	def initialize(nuclide, datasource="internal")
		# TODO: throw
		@nuclide = nuclide.to_s
		@intensities = case datasource
			when "internal" then datasource_internal(@nuclide)
			when "nucleide.org" then datasource_nucleideorg(@nuclide)
			else raise "Unknown Datasource"
		end
	end

	def energies
		@intensities.collect{|line| line[:energy]}
	end

end
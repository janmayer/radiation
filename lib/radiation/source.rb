# encoding: utf-8
require 'radiation/source/resource'
require 'combinatorics'


module Radiation
class Source
	attr_reader :data

	def initialize(options={})
		@resource = options.key?(:resource) ? options[:resource].to_s : "internal"
		fetch(options[:nuclide].to_s) if options.key?(:nuclide)
	end

	def fetch(nuclide)
		raise "Nuclide :#{nuclide} is not valid." unless is_nuclide?(nuclide)
		@data = Resource.new(@resource).data(nuclide)
	end

	def nuclide
		@data[:nuclide]
	end

	def energies
		@data[:lines].collect{|line| line[:energy]}
	end

	def intensities
		@data[:lines].select{|line| line[:intensity] > 0}.collect{|line| {:energy => line[:energy], :intensity => line[:intensity]} }
	end

	def is_nuclide?(nuclide)
		!!(nuclide =~ /\A[a-zA-Z]{1,2}-\d{1,3}\z/)
	end

end
end
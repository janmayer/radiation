# encoding: utf-8
require 'radiation/source/resource/internal'
require 'radiation/source/resource/nucleideorg'

class Radiation::Source
	class Resource
		
		def initialize(resource)
			@resource = resource
		end

		def data(nuclide)
			@data = {}
			case @resource
				when "internal" then datasource_internal(nuclide)
				when "nucleide.org" then datasource_nukleideorg(nuclide)
				else raise "Unknown Datasource"
			end
			return @data
		end

	end
end

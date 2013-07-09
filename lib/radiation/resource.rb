# encoding: utf-8

module Radiation
	module Resource
		class Base
			attr_reader :data

			def initialize()
				@data = {}
			end

		end
	end
end
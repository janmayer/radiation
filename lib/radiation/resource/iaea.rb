# encoding: utf-8
require 'json'

module Radiation::Resource
	class IAEA < Base
		# FIXME: Better path creation
		PATH = File.join(File.dirname(__FILE__), "../../../data")
		FILENAME = "iaea-xgamma.json"

		def fetch(nuclide)
			@nuclide = nuclide
			begin
				@data = load_data.select{|n| n[:nuclide] == nuclide}.first
				# FIXME: Better conversion from x, x_uncertainty to pm
				@data[:transitions].collect!{|t| { :energy => t[:energy].to_f.pm(t[:energy_uncertainty].to_f), :intensity => t[:intensity].to_f.pm(t[:intensity_uncertainty].to_f)} }
			rescue
				raise "No Data for #{@nuclide}"
			end
			self
		end

		def list
			load_data.collect{|n| n[:nuclide]}
		end

		private
		def load_data
			JSON.parse( IO.read("#{PATH}/#{FILENAME}"), {:symbolize_names => true} )
		end

	end
end

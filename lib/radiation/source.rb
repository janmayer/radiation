# encoding: utf-8
module Radiation
	class Source
		attr_reader :resource, :nuclide, :halflife, :reference, :description, :transitions
	
		def initialize(options={})
			@resource = options.key?(:resource) ? options[:resource].to_s : "internal"
			@nuclide  = options[:nuclide].to_s if options.key?(:nuclide)
			fetch if @resource and @nuclide
		end
	
		def fetch(options={})
			@resource = options[:resource].to_s if options.key?(:resource)
			@nuclide  = options[:nuclide].to_s  if options.key?(:nuclide)
			raise "Nuclide: #{@nuclide} is not valid." unless is_nuclide?(@nuclide)
			data = case @resource
				when "internal" then Radiation::Resource::Internal.new.fetch(@nuclide).data
				when "iaea" then Radiation::Resource::IAEA.new.fetch(@nuclide).data
				when "nucleide.org" then Radiation::Resource::Nucleideorg.new.fetch(@nuclide).data
				else raise "Unknown Datasource"
			end
			build(data)
			return self
		end

		def resources
			["internal", "iaea", "nucleide.org"]
		end
	
		def read(options={})
			@resource = "external"
			build(options)
			return self
		end
	
		def energies
			self.transitions.collect{|line| line[:energy]}
		end
	
		def intensities
			self.transitions.select{|line| line[:intensity] > 0}.collect{|line| {:energy => line[:energy], :intensity => line[:intensity]} }
		end
	
		def is_nuclide?(nuclide)
			!!(nuclide =~ /\A[a-zA-Z]{1,2}-\d{1,3}\z/)
		end
	
	private
		def build(data)
			[:nuclide, :halflife, :reference, :description, :transitions].each do |key|
				instance_variable_set("@#{key}", data[key]) if data.key?(key)
			end
		end
	
	end
end
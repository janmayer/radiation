# encoding: utf-8
require 'combinatorics'
require "linefit"
require "plusminus"
require "xmlsimple"

module Radiation
	class Spectrum
		attr_accessor :peaks, :source, :calibration
	
		def initialize(options={})
			@peaks		= options.key?(:peaks) ? options[:peaks] : []
			@source		= options.key?(:source) ? options[:source] : nil
			@calibration= options.key?(:calibration) ? options[:calibration] : [0, 1]
		end
	
		def calibrate
			if @peaks.empty? or @peaks.select{|p| p.key?(:channel)}.empty?
				raise "Nothing to calibrate"
			end
	
			if @peaks.select{|p| p.key?(:channel) and p.key?(:energy)}.empty?
				if @calibration == [0,1] and @source.nil?
					raise "No channel <-> energy associations. Specify a Source or a preliminary calibration to improve"
				else
					self.guess_calibration
				end
				self.match_channels
			end

			@calibration = apply_linefit(@peaks)
			return self
		end
	
		def guess_calibration(energies=@source.energies, rounding=4)
			# Build all possible combinations of known energies and peaks
			arr = [energies, @peaks.collect{|peak| peak[:channel]}].comprehension
			# The approximate value for b in $Energy = a + b * Channel$ will be most frequent for $a \approx 0$
			freq = arr.collect{|a| (a.first.to_f/a.last.to_f).round(rounding) }.flatten.inject(Hash.new(0)) { |h,v| h[v] += 1; h }.sort_by{|k,v| v}
			@calibration = [0, freq.last[0] ]
			return self
		end
	
		def channel_energy(chn)
			@calibration[0] + @calibration[1]*chn
		end
	
		def parse_hdtv(file)
			xml = XmlSimple.xml_in(file, { 'KeyAttr' => 'name' })
			@peaks = xml["fit"].collect{|p| p["peak"]}.flatten.collect{|p| p["uncal"]}.flatten.collect do |p|
				{:channel => p["pos"].first["value"].first.to_f.pm(p["pos"].first["error"].first.to_f),
		 		:counts => p["vol"].first["value"].first.to_f.pm(p["vol"].first["error"].first.to_f) } 
			end
			return self
		end
		
		def efficiencies(rounding=4)
			self.match_channels
			@peaks.select{|p| p.key?(:intensity) and p.key?(:counts)}.each{|p| p[:efficiency] = channel_efficiency(p)}
			return self
		end

		def match_channels(source=@source, rounding=4)
			@peaks.each do |peak|
				source.transitions.each do |transition|
					if channel_energy(peak[:channel]).to_f.approx_equal?(transition[:energy], rounding)
						peak[:energy] = transition[:energy]
						peak[:intensity] = transition[:intensity] if transition[:intensity] > 0
					end
				end
			end
			return self
		end


		def channel_efficiency(peak)
			peak[:counts]/peak[:intensity]
		end

	private
		def apply_linefit(peaks)
			#calibrate using linefit
			mpeaks = peaks.delete_if{|p| p[:energy] == nil}
			x = mpeaks.collect{|p| p[:channel]}
			y = mpeaks.collect{|p| p[:energy]}
			lineFit = LineFit.new

			# Use weighted calibration when possible
			if mpeaks.count{|p| p[:intensity] and p[:intensity] > 0} == mpeaks.count
				weights = mpeaks.collect{|p| p[:intensity].nil? ? 0 : p[:intensity]}
				lineFit.setData(x,y,weights)
			else
				lineFit.setData(x,y)
			end
			
			intercept, slope = lineFit.coefficients
			varianceIntercept, varianceSlope = lineFit.varianceOfEstimates
			return [intercept.pm(Math.sqrt(varianceIntercept.abs)), slope.pm(Math.sqrt(varianceSlope.abs))]
		end

	end
end
	
	
class Float
	def approx_equal?(other,threshold=0.5)
		if (self-other).abs < threshold    # "<" not exact either
			return true
		else
			return false
		end
	end
end
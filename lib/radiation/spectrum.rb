# encoding: utf-8
require "linefit"
require "plusminus"

class Radiation::Spectrum
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
				raise "No channel <-> energy associations. Specify a Source or a preleminary calibration to improve"
			else
				self.guess_calibration
			end
			self.match_channels
		end
		#calibrate using linefit
		mpeaks = @peaks.delete_if{|p| p[:energy] == nil}
		x = mpeaks.collect{|p| p[:channel]}
		y = mpeaks.collect{|p| p[:energy]}
		lineFit = LineFit.new
		lineFit.setData(x,y)
		intercept, slope = lineFit.coefficients
		varianceIntercept, varianceSlope = lineFit.varianceOfEstimates
		@calibration = [intercept.pm(Math.sqrt(varianceIntercept)), slope.pm(Math.sqrt(varianceSlope))]
		return self
	end

	def match_channels(energies=@source.energies, rounding=4)
		@peaks.each do |peak|
			energies.each do |energy|
				peak[:energy] = energy if channel_energy(peak[:channel]).approx_equal?(energy, rounding)
			end
		end
		return self
	end

	def guess_calibration(energies=@source.energies, rounding=3)
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
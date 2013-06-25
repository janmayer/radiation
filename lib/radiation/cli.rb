# encoding: utf-8
require "radiation"
require "thor"

module Radiation
class CLI < Thor

	desc "version", "Prints version information"
	def version
		puts "radiation version #{Radiation::VERSION}"
	end
	map %w(-v --version) => :version

	option :resource
	desc "source NUCLIDE", "decay radiation data"
	def source(nuclide)
		resource = options[:resource] ? options[:resource] : "internal"
		puts ["E_ɣ", "ΔE_ɣ", "I_ɣ", "ΔI_ɣ"].join("\t")
		puts Radiation::Source.new(nuclide: nuclide, resource: resource).intensities.collect{|l| [l[:energy].value, l[:energy].delta, l[:intensity].value, l[:intensity].delta].join("\t") }
	end

	option :resource
	desc "calibrate NUCLIDE SPECTRUM.xml", "calibrate a spectrum"
	long_desc <<-LONGDESC
	Calibrates a decay radiation spectrum that has been analysed with HDTV. Stored peak fits in HDTV can be stored with hdtv>fit write filname.xml
	Example: \n
	$>radiation calibrate Ra-226 Ge00.xml
	With --resource=nucleide.org more decay radiation sources are available.
	LONGDESC
	def calibrate(nuclide, file)
		resource = options[:resource] ? options[:resource] : "internal"
		source   = Radiation::Source.new(nuclide: nuclide, resource: resource)
		spectrum = Radiation::Spectrum.new(source: source ).parse_hdtv(file)
		spectrum.calibrate.calibration.each{|c| puts c}
	end

end
end
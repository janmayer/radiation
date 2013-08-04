# encoding: utf-8
require 'radiation'

file     = "./B0-Ra226.xml"
source   = Radiation::Source.new(nuclide: "Ra-226", resource: "nucleide.org")

puts ["E_ɣ", "I_ɣ", "ΔI_ɣ", "e", "Δe"].join("\t")
Radiation::Spectrum.new(source: source).parse_hdtv(file).calibrate.efficiencies.select{|p| p[:intensity] > 0.3}.sort_by{|k| k[:energy]}.each do |p|
	puts "#{p[:energy].to_f.round(1)}\t#{p[:intensity].value}\t#{p[:intensity].delta}\t#{p[:efficiency].value.round(1)}\t#{p[:efficiency].delta.round(1)}"
end
# encoding: utf-8
require 'radiation'

file     = "./B0-Ra226.xml"
source   = Radiation::Source.new(nuclide: "Ra-226")
spectrum = Radiation::Spectrum.new(source: source ).parse_hdtv(file)

spectrum.calibrate.calibration.each{|c| puts c}
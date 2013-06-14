# encoding: utf-8
require 'radiation'

channels = [512.9592, 668.6611, 715.773, 759.483, 817.0175, 975.0220, 1075.977, 1124.82, 1261.666, 1281.123, 1333.194, 1351.650, 1417.69, 1481.380, 1610.736, 1691.9637, 1848.412, 1953.350, 2000.193, 2135.6125, 2184.578, 2241.203, 2332.889, 2595.4352, 2678.202, 3112.7327, 3209.900, 3440.820, 3560.182, 3829.513, 3850.791, 3895.915, 3913.953, 4196.125, 4621.221, 4811.183, 4908.2438, 5139.402, 5895.042, 6133.533, 6811.046]
peaks    = channels.collect{|a| {channel: a} }
source   = Radiation::Source.new(nuclide: "Ra-226")
spectrum = Radiation::Spectrum.new(peaks: peaks, source: source )

puts spectrum.calibrate.calibration.to_s

puts "\n"

puts spectrum.peaks.collect{|p| [ p[:channel], p[:energy] ].join("\t") }
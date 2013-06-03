# encoding: utf-8
require 'radiation'
require 'csv'

puts ["E_ɣ", "ΔE_ɣ", "I_ɣ", "ΔI_ɣ"].join("\t")
puts Radiation::Source.new(nuclide: "Ra-226", resource: "nucleide.org").intensities.collect{|l| [l[:energy].value, l[:energy].delta, l[:intensity].value, l[:intensity].delta].join("\t") }
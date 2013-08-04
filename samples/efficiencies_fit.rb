# encoding: utf-8
require 'radiation'

file     = "./B0-Ra226.xml"
source   = Radiation::Source.new(nuclide: "Ra-226", resource: "nucleide.org")

puts ["E_ɣ", "I_ɣ", "ΔI_ɣ", "e", "Δe"].join("\t")
peaks = Radiation::Spectrum.new(source: source).parse_hdtv(file).calibrate.efficiencies.peaks.select{|p| p[:intensity] > 0.3}.sort_by{|k| k[:energy]}
peaks.each do |p|
	puts "#{p[:energy].to_f.round(1)}\t#{p[:intensity].value}\t#{p[:intensity].delta}\t#{p[:efficiency].value.round(1)}\t#{p[:efficiency].delta.round(1)}"
end


require 'open3'
require 'tmpdir'

variables = ["a","b","c"]

gnuplot_commands = <<"End"
  # Activate fit errors
  set fit errorvariables
  # Disable fit logging
  set fit quiet
  set fit logfile "#{Dir.tmpdir}/radiation/fit.log"
  # Redirect print output to stdout
  set print "-"
  # Prepare fit
  a = #{peaks.first[:efficiency]}
  b = 0.2
  c = #{peaks.first[:efficiency]}
  d = 0.2
  f(x) = a*exp(-b*b*x)+c#*exp(-d*d*x)
  fit f(x) "-" via a,b,c#,d
End

peaks.each do |p|
  gnuplot_commands << "#{p[:energy]} #{p[:efficiency]}\n"
end
gnuplot_commands << "e\n"

variables.each do |v|
	gnuplot_commands << "print #{v}, #{v}_err\n"
end

values, s = Open3.capture2("gnuplot", :stdin_data=>gnuplot_commands, :binmode=>true)

puts values
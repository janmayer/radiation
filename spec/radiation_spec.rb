# encoding: utf-8
require 'spec_helper'

describe Radiation do
	describe Radiation::Source do
		name = "Ra-226"
		source = Radiation::Source.new(nuclide: name)

		it "provides information about itself" do
			source.nuclide.should eq(name)
			#source.reference.should be_a_kind_of(String)
			#source.halflive.should be_a_kind_of(Plusminus::PlusminusFloat)
		end

		it "returns an array with gamma-ray energies for a given source" do
			source.energies.should be_a_kind_of(Array)
			source.energies.length.should be > 0
			source.energies[0].should be_a_kind_of(Plusminus::PlusminusFloat)
		end

		it "returns intensities for energies" do
			source.intensities.should be_a_kind_of(Array)
			source.intensities.first.should be_a_kind_of(Hash)
			source.intensities.length.should be > 0
		end
		it "can access different data resources" do
			expect { Radiation::Source.new(nuclide: "Ra-226") }.to_not raise_error
			expect { Radiation::Source.new(nuclide: "Ra-226", resource: "nucleide.org") }.to_not raise_error
		end

		it "cheks for valid nuclei" do
			Radiation::Source.new.is_nuclide?("Nukular9000").should be false
			Radiation::Source.new.is_nuclide?("226Ra-226").should be false
			Radiation::Source.new.is_nuclide?("Ra-226").should be true
			Radiation::Source.new.is_nuclide?("C-14").should be true
			Radiation::Source.new.is_nuclide?("H-1").should be true
			expect { Radiation::Source.new(nuclide: "Nukular9000") }.to raise_error
			expect { Radiation::Source.new(nuclide: "Ra-226") }.to_not raise_error
		end
		it "gives an error if no record is found" do
			expect { Radiation::Source.new(nuclide: "Ra-15") }.to raise_error
			expect { Radiation::Source.new(nuclide: "Ra-15", resource: "nucleide.org") }.to raise_error
		end
	end

	describe Radiation::Spectrum do
		channels = [512.9592, 668.6611, 715.773, 759.483, 817.0175, 975.0220, 1075.977, 1124.82, 1261.666, 1281.123, 1333.194, 1351.650, 1417.69, 1481.380, 1610.736, 1691.9637, 1848.412, 1953.350, 2000.193, 2135.6125, 2184.578, 2241.203, 2332.889, 2595.4352, 2678.202, 3112.7327, 3209.900, 3440.820, 3560.182, 3829.513, 3850.791, 3895.915, 3913.953, 4196.125, 4621.221, 4811.183, 4908.2438, 5139.402, 5895.042, 6133.533, 6811.046]
		peaks = channels.collect{|a| {channel: a} }
		source = Radiation::Source.new(nuclide: "Ra-226")

		it "can guess a inital energy calibration based on adc values" do
			Radiation::Spectrum.new(peaks: peaks, source: source).guess_calibration.calibration.should be == [0, 0.3597]
		end

		it "can match channels to given energies by using a calibration" do
			Radiation::Spectrum.new(peaks: peaks, source: source ).guess_calibration.match_channels.peaks[0][:energy].should be == 186.2
		end

		it "can calibrate a spectrum" do
			expect { Radiation::Spectrum.new(peaks: peaks, source: source ).calibrate }.to_not raise_error
			Radiation::Spectrum.new(peaks: peaks, source: source ).calibrate.calibration[0].should be_a_kind_of(Plusminus::PlusminusFloat)
		end

		it "can read peaks from hdtv xml data" do
			expect { Radiation::Spectrum.new(source: source ).parse_hdtv("./samples/B0-Ra226.xml") }.to_not raise_error
			Radiation::Spectrum.new(source: source ).parse_hdtv("./samples/B0-Ra226.xml").calibrate.calibration[1].to_f.should be_within(0.001).of(0.1)
		end

	end
end
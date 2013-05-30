# encoding: utf-8
require 'spec_helper'

describe Radiation do
	describe Radiation::Source do
		name = "Ra-226"
		source = Radiation::Source.new(name)


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

	end
end
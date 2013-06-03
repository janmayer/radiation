# encoding: utf-8
require 'spec_helper'

describe Radiation do
	describe Radiation::Source do

		describe "Features" do
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
	
		end

		describe "Errors" do
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

	end
end
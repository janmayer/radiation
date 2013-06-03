# Radiation [![Build Status](https://travis-ci.org/janmayer/radiation.png?branch=master)](https://travis-ci.org/janmayer/radiation)

This gem provides easy access to energies and intensities from the decay of radioactive nuclei. 
Currently two data sources are accessible: Internal (see bib files in `./data/`) and recommended values 
by [Laboratoire National Henri Becquerel](http://www.nucleide.org/DDEP_WG/DDEPdata.htm)

## Example Usage

    Radiation::Source.new(nuclide: "Ra-226").energies.collect{|e| e.value}


## Planned features

Energy and efficiency calibration for given peaks or spectra.


## Installation

Requirement is a (local) ruby with rubygems. Using rvm is recommended
    
    $ \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

Add this line to your application's Gemfile:

    gem 'radiation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install radiation

# Radiation
[![Gem Version](https://badge.fury.io/rb/radiation.png)](http://badge.fury.io/rb/radiation)
[![Build Status](https://travis-ci.org/janmayer/radiation.png?branch=master)](https://travis-ci.org/janmayer/radiation)
[![Code Climate](https://codeclimate.com/github/janmayer/radiation.png)](https://codeclimate.com/github/janmayer/radiation)

This gem provides easy access to energies and intensities from the decay of radioactive nuclei. 
Currently two data sources are accessible: Internal (see bib files in `./data/`) and recommended values 
by [Laboratoire National Henri Becquerel](http://www.nucleide.org/DDEP_WG/DDEPdata.htm).

## Example Usage

    Radiation::Source.new(nuclide: "Ra-226").energies.collect{|e| e.value}

See also files in `./samples/`.


## Planned features

* Efficiency calibration for given peaks or spectra
* CLI
* Better access to resources


## Installation

Requirement is a (local) ruby with rubygems. Using rvm is recommended
    
    $ \curl -L https://get.rvm.io | bash -s stable --ruby=1.9.3

Add this line to your application's Gemfile:

    gem 'radiation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install radiation

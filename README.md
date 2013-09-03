# Radiation
[![Gem Version](https://badge.fury.io/rb/radiation.png)](http://badge.fury.io/rb/radiation)
[![Build Status](https://travis-ci.org/janmayer/radiation.png?branch=master)](https://travis-ci.org/janmayer/radiation)
[![Code Climate](https://codeclimate.com/github/janmayer/radiation.png)](https://codeclimate.com/github/janmayer/radiation)

This gem provides easy access to energies and intensities from the decay of radioactive nuclei. 
Currently two data sources are accessible:

* IAEA [xgamma](http://www-nds.iaea.org/xgamma_standards/) recommended values (default)
* Laboratoire National Henri Becquerel [DDEP](http://www.nucleide.org/DDEP_WG/DDEPdata.htm) recommended data

Note that IAEA data is compiled and filtered with energy and efficiency calibration in mind, while DDEP data ist focused on completeness.


## Example Usage

The radiation gem can be use in two ways:

### Command line interface

	$ radiation
	$ radiation source Na-22
	=> E_ɣ      ΔE_ɣ    I_ɣ     ΔI_ɣ
	=> 511.0    0.0     1.798   2E-03
	=> 1274.537 0.003   0.9994  1E-04

Refer to the CLI for more options.

### In your ruby files:

    require "radiation"
    Radiation::Source.new(nuclide: "Ra-226").energies.collect{|e| e.value}

See files in `./samples/`.


## Installation

Requirement is a (local) ruby with rubygems. Using rvm is recommended

### Installing ruby locally on a debian based system
    
    $ \curl -L https://get.rvm.io | bash -s stable
    $ source ~/.bashrc
    $ rvm mount -r http://rvm.io/binaries/debian/7.0/x86_64/ruby-2.0.0-p247.tar.bz2 --verify-downloads 1
    $ rvm use --default 2.0.0

### Installing the gem

    $ gem install radiation

Or use bundler.
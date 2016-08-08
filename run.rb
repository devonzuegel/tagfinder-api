require 'rubygems'
require 'bundler'

Bundler.require

require './lib/tagfinder/app'

Tagfinder::App.run!

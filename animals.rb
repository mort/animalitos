require "rubygems"
require "bundler/setup"

require 'geohash'
require 'csquares'
require "redis"

require 'rufus/mnemo'

require 'rgeo'
require 'geocoder'
require 'geokit'

require 'observer'
require 'securerandom'


require Dir[File.dirname(__FILE__) + '/lib/movable.rb'].first
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }




















require "rubygems"
require "bundler/setup"

require 'geohash'
require 'csquares'
require "redis"

require 'rufus/mnemo'
require 'cartodb-rb-client'

require 'rgeo'
require 'geocoder'
require 'geokit'

require 'observer'
require 'securerandom'


require File.dirname(__FILE__) + '/lib/movable.rb'
require File.dirname(__FILE__) + '/lib/temperament.rb'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

CartoDB::Init.start YAML.load_file('./config/cartodb.yml')





















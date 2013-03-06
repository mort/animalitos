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

require 'httparty'

require 'observer'
require 'securerandom'


%w(movable temperament feeder).each {|f| require File.dirname(__FILE__) + "/lib/#{f}.rb" }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

CartoDB::Init.start YAML.load_file(File.dirname(__FILE__)+'/config/cartodb.yml')





















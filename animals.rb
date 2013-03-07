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
require 'streams'

require 'observer'
require 'securerandom'



Dir[File.dirname(__FILE__) + '/lib/traits/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

CartoDB::Init.start YAML.load_file(File.dirname(__FILE__)+'/config/cartodb.yml')





















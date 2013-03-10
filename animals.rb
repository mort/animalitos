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
require 'cocaine'

require 'observer'
require 'securerandom'

include ActivityStreams
include Observable

Dir[File.dirname(__FILE__) + '/lib/traits/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

CartoDB::Init.start YAML.load_file(File.dirname(__FILE__)+'/config/cartodb.yml')





















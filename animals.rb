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

require 'celluloid'

require 'httparty'
require 'streams'
require 'cocaine'

require 'observer'
require 'securerandom'
require 'csv'

require File.dirname(__FILE__) + '/lib/streamable.rb'
Dir[File.dirname(__FILE__) + '/lib/ext/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/traits/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/services/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

CartoDB::Init.start YAML.load_file(File.dirname(__FILE__)+'/config/cartodb.yml')

include ActivityStreams
include Observable
include Siblings



















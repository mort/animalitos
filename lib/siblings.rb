require 'geohash'
require 'csquares'
require "redis"
require 'rufus/mnemo'
#require 'cartodb-rb-client'
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
require 'logger'
require 'edr'
require 'active_record'

#CartoDB::Init.start YAML.load_file File.expand_path('/../config/cartodb.yml', __FILE__)

module Siblings

  autoload :Animalito,   'siblings/animalito'   
  autoload :Bond,        'siblings/bond'
  autoload :Bump,        'siblings/bump'
  autoload :Feeding,     'siblings/feeding'
  autoload :Inbox,       'siblings/inbox'
  autoload :Journey,     'siblings/journey'
  autoload :Location,    'siblings/location'
  autoload :Luma,        'siblings/luma'
  autoload :Player,      'siblings/player'
  autoload :Position,    'siblings/position'
  autoload :Route,       'siblings/route'
  autoload :Score,       'siblings/score'
  autoload :Scuffle,     'siblings/scuffle'
  autoload :Temperament, 'siblings/temperament'
  autoload :Liking,      'siblings/liking'

  module Streamable
    
    autoload :Streamer,    'siblings/streamer'
    
    autoload :Animalito,   'siblings/streamable'
    autoload :Scuffle,     'siblings/streamable'
    autoload :Location,    'siblings/streamable'
    autoload :Player,      'siblings/streamable'
    autoload :Bump,        'siblings/streamable'
    autoload :Position,    'siblings/streamable'
    autoload :Feeding,     'siblings/streamable'
    autoload :Journey,     'siblings/streamable'
    autoload :Liking,      'siblings/streamable'
    autoload :Venue,       'siblings/streamable'
    
  end
  
  module Services
    autoload :Foursquare, 'siblings/services/foursquare'
    autoload :Weather,    'siblings/services/weather'
    autoload :Venue,      'siblings/services/venue'

  end
  
  module Traits 
    autoload :Enjoys, 'siblings/traits/enjoys'
    autoload :Feeds,  'siblings/traits/feeds'
    autoload :Moves,  'siblings/traits/moves'
    autoload :Sleeps, 'siblings/traits/sleeps'
    autoload :Talent, 'siblings/traits/talent'
  end
  
  module Data
    autoload :Animalito, 'siblings/data/animalito'
    autoload :Location,  'siblings/data/location'
    autoload :Position,  'siblings/data/position'
    
  end
  
  module Repositories
    autoload :Animalito, 'siblings/repositories/animalito'
  end
  
  include Observable
  include ActivityStreams
end

module Siblings
  class <<self
    attr_accessor :logger
  end
end

Siblings.logger = Logger.new('/tmp/siblings.log')

require 'siblings/version'
require 'siblings/ext/array'
require 'siblings/ext/float'


include Siblings

Edr::Registry.define do
  
  #%w(animalito position location).each do |c|
  #  a =  ['siblings', c].map!{|s| s.capitalize}.join('::').constantize
  #  b =  ['siblings', 'data', c].map!{|s| s.capitalize}.join('::').constantize
   # map a, b
  #end
  map Siblings::Animalito, Siblings::Data::Animalito
  map Siblings::Position,  Siblings::Data::Position
  map Siblings::Location,  Siblings::Data::Location

  
end

ActiveRecord::Base.establish_connection(:adapter => "mysql2",:host => "localhost",:database => "siblings_dev",:username => "root", :password => "")
















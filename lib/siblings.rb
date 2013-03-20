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
require 'logger'

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
    
  end
  
  module Services
    autoload :Foursquare, 'siblings/services/foursquare'
    autoload :Weather,    'siblings/services/weather'
  end
  
  module Traits 
    autoload :Enjoys, 'siblings/traits/enjoys'
    autoload :Feeds,  'siblings/traits/feeds'
    autoload :Moves,  'siblings/traits/moves'
    autoload :Sleeps, 'siblings/traits/sleeps'
    autoload :Talent, 'siblings/traits/talent'
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















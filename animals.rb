require "rubygems"
require "bundler/setup"

require 'geohash'
require 'csquares'
require "redis"

require 'observer'
require 'securerandom'


require Dir[File.dirname(__FILE__) + '/lib/distance.rb'].first
require Dir[File.dirname(__FILE__) + '/lib/movable.rb'].first
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }




















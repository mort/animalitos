require "rubygems"
require "bundler/setup"

require 'geohash'
require 'csquares'
require "redis"

require 'observer'
require 'securerandom'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }




















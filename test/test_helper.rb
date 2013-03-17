require 'pry'

require 'bundler/setup'
require 'minitest/spec'
require 'minitest/autorun' 
require 'minitest-spec-context'
begin; require 'turn/autorun'; rescue LoadError; end

require File.expand_path('../../lib/siblings.rb', __FILE__)
include Siblings
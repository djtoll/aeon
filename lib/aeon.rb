require 'rubygems'
require 'ruby-debug'

# Add the lib directory to Ruby's load path.
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) ||
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
  
##### Setup DataMapper
require 'dm-core'
DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/db.sqlite3')
# Monkey patch that makes DM's Identity Map global.
require 'aeon/dm-core_ext/identity_map'

AEON_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

module Aeon; end # Initialize the Aeon namespace.

require 'aeon/core_ext/module'

require 'aeon/logger'
require 'aeon/reloader'
require 'aeon/server'
require 'aeon/client'
require 'aeon/connector'
require 'aeon/world'
require 'aeon/room'
require 'aeon/character'
require 'aeon/player'

module Aeon
  class << self
    attr_reader   :world  # Global instance of the World object
    attr_reader   :logger # Global instance of the Logger
    attr_accessor :mode   # Aeon's run mode (:development, :test, or :production)
  end
  @world  = Aeon::World.new
  @logger = Aeon::Logger.new
end
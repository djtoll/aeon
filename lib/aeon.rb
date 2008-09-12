require 'rubygems'
require 'ruby-debug'

# Setup datamapper
require 'dm-core'
require 'dm-timestamps'
DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/db.sqlite3')

# Add the lib directory to Ruby's load path.
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) ||
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

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

# NOTE: turns out the reloader was a bad idea.
#
# Set the Reloader up to observe these files:
# Aeon::Reloader.observe_files do |r|
#   r.observe 'aeon/world'
#   r.observe 'aeon/room'
#   r.observe 'aeon/character'
#   r.observe 'aeon/player'
# end

module Aeon
  class << self
    attr_reader   :world  # Global instance of the World object
    attr_reader   :logger # Global instance of the Logger
    attr_accessor :mode   # Accessor for Aeon's run mode, e.g :development, :test, :production
  end
  @world  = Aeon::World.new
  @logger = Aeon::Logger.new
end
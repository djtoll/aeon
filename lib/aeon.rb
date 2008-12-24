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

require 'aeon/core_ext/module'
require 'aeon/logger'

module Aeon
  class << self
    attr_reader   :logger # Global instance of the Logger
    attr_accessor :mode   # Aeon's run mode (:development, :test, or :production)
    attr_reader   :config 
  end
  @logger = Logger.new
  @config = {}
end

require 'aeon/loader'
require 'aeon/color'
require 'aeon/server'
require 'aeon/client'
require 'aeon/connector'
require 'aeon/world'
require 'aeon/room'
require 'aeon/character'
require 'aeon/commandable'
require 'aeon/player'
require 'aeon/event'

# Aeon::Loader.observe_files do |r|
#   r.load 'aeon/connector'
#   r.load 'aeon/world'
#   r.load 'aeon/room'
#   r.load 'aeon/character'
#   r.load 'aeon/commandable'
#   r.load 'aeon/player'
# end
require 'matrix'

require 'rubygems'
require 'ruby-debug'

# Add the lib directory to Ruby's load path.
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) ||
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

AEON_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

require 'dm-core'
DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/db.sqlite3')

# Monkey patch that makes DM's Identity Map global.
require 'aeon/extensions/dm-core/identity_map'

require 'aeon/extensions'
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

# require 'aeon/loader'
require 'aeon/color'
require 'aeon/server'
require 'aeon/client'
require 'aeon/connector'
require 'aeon/world'
require 'aeon/models/room'
require 'aeon/models/character'
require 'aeon/models/commandable'
require 'aeon/models/player'
require 'aeon/event'

# Aeon::Loader.observe_files do |r|
#   r.load 'aeon/connector'
#   r.load 'aeon/world'
#   r.load 'aeon/models/room'
#   r.load 'aeon/models/character'
#   r.load 'aeon/models/commandable'
#   r.load 'aeon/models/player'
#   r.load 'aeon/event'
# end
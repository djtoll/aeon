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

require 'aeon/server'
require 'aeon/client'
require 'aeon/connector'
require 'aeon/world'
require 'aeon/room'
require 'aeon/character'
require 'aeon/player'

module Aeon
  class << self
    attr_reader :world
  end
  @world = Aeon::World.new
  puts "Initialized Aeon World: #{@world.inspect}"
end
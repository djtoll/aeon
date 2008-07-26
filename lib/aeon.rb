require 'rubygems'
require 'ruby-debug'

# Setup datamapper
require 'dm-core'
require 'dm-timestamps'
DataMapper.setup(:default, :adapter => 'sqlite3', :database => 'db/db.sqlite3')

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) unless
  $LOAD_PATH.include?(File.dirname(__FILE__)) ||
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

module Aeon
end

require 'aeon/server'
require 'aeon/connection_handler'
require 'aeon/player'
require 'aeon/connector'
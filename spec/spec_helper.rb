require 'rubygems'
require 'spec'

require File.join(File.dirname(__FILE__), '..', 'lib', 'aeon')

# Setup the test database using in-memory SQLite3
require 'dm-core'
DataMapper.setup(:default, 'sqlite3::memory:')

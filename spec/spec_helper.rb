require 'rubygems'
require 'spec'

# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'

# matchers
require File.dirname(__FILE__) + '/matchers/output_matchers'
include OutputMatchers

# mocks
require File.dirname(__FILE__) + '/mocks/mock_client'

# Setup the test database using in-memory SQLite3
require 'dm-core'
DataMapper.setup(:default, 'sqlite3::memory:')
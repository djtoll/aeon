require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/factory'

# require the Aeon library
require File.dirname(__FILE__) + '/../lib/aeon'
Aeon.mode = :test

# matchers
require File.dirname(__FILE__) + '/matchers/output_matchers'
include OutputMatchers

# mocks
require File.dirname(__FILE__) + '/mocks/mock_client'

# Setup the test database using in-memory SQLite3
DataMapper.setup(:default, 'sqlite3::memory:')

Spec::Runner.configure do |config|
  config.before(:each) do
    DataMapper.auto_migrate!
    DataMapper::Repository.reset_identity_maps!
  end
end
require 'lib/aeon.rb'

namespace :db do
  desc "Invokes DataMapper.auto_migrate!"
  task :migrate do
    DataMapper.auto_migrate!
  end
end
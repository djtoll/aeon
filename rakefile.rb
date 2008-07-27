require 'lib/aeon.rb'

task :db do
  exec "sqlite3 db/db.sqlite3"
end

task :console do
  exec "irb -r aeon.rb"
end

namespace :db do
  desc "Invokes DataMapper.auto_migrate!"
  task :migrate do
    DataMapper.auto_migrate!
  end
end
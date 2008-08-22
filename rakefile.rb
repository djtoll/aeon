require 'lib/aeon.rb'

desc "Opens up db/db.sqlite3 with the sqlite3 client."
task :db do
  exec "sqlite3 db/db.sqlite3"
end

namespace :db do
  desc "Invokes DataMapper.auto_migrate!"
  task :migrate do
    DataMapper.auto_migrate!
  end
  
  desc "Auto migrate the DB and reload the development world in db/world.rb"
  task :reload do
    DataMapper.auto_migrate!
    Kernel.load('db/world.rb')
  end
end
require 'eventmachine'

module Aeon
  
  module Server
    def self.start
      EventMachine.run do
        # Aeon::Client is mixed into EventMachine::Connection. It's where the
        # magic happens.
        EventMachine.start_server('127.0.0.1', 5000, Client)
        puts "Aeon game server listening on port 5000"
        
        # fn = "/tmp/aeon_admin.chain"
        # File.unlink(fn) if File.exist?(fn)
        # EventMachine.start_unix_domain_server(fn, Aeon::TestUnixServer)
        # puts "Aeon admin socket open at #{fn}"
        
        EventMachine.start_server('127.0.0.1', 5001, AdminServer)
        puts "Aeon admin server listening on port 5001"
      
        World.new
      
        if Aeon.mode == :development
          # Aeon::Loader.run
          DataMapper.logger.set_log(STDOUT, :debug)
          DataMapper.logger.debug("Datamapper logging to STDOUT.")
        end
      end
    end
  end
  
  # Right now, the admin side exists only for reloading rooms that are in the
  # IdentityMap. The web interface uses this after it updates a Room.
  module AdminServer
    def receive_data(data)
      if ip_address == "127.0.0.1"
        Aeon::Room.get(data.to_i).reload
      end
    end
    
    def ip_address
      Socket.unpack_sockaddr_in(get_peername)[1]
    end
  end
  
end
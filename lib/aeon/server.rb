require 'eventmachine'

module Aeon::Server
  
  def self.start
    EventMachine.run do
      # Start EventMachine, telling it to use Aeon::Client for connections.
      EventMachine.start_server('0.0.0.0', 5000, Aeon::Client)
      puts "Server listening on 0.0.0.0 port 5000"
      
      Aeon::World.new
      
      if Aeon.mode == :development
        # Aeon::Loader.run
        DataMapper.logger.set_log(STDOUT, :debug)
        DataMapper.logger.debug("Datamapper logging to STDOUT.")
      end
    end
  end
  
end
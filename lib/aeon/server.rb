require 'eventmachine'

module Aeon::Server
  def self.start
    # Start the reloader if in development mode.
    # DISABLED -- see Aeon::Reloader for info.
    # Aeon::Reloader.run if Aeon.mode == :development
    
    # Start EventMachine, telling it to use Aeon::Client for connections.
    EventMachine.run do
      EventMachine.start_server('0.0.0.0', 5000, Aeon::Client)
      puts "Server listening on 0.0.0.0 port 5000"
    end
  end
end
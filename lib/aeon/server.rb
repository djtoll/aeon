require 'eventmachine'

module Aeon::Server
  def self.start
    EventMachine.run do
      EventMachine.start_server('0.0.0.0', 5000, Aeon::Client)
      # puts "Server listening on 0.0.0.0 port 5000"
    end
  end
end
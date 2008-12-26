# This is the module which gets mixed into EventMachine::Connection when the
# server starts. EventMachine::Connection provides three hooks for us to
# override: post_init, receive_data, and unbind.

module Aeon
  module Client

    attr_reader :player
  
    # Called when the client connects
    def post_init
      @connector = Aeon::Connector.new(self)
    end
  
    # Called when we receive data from the client
    def receive_data(data)
      if @player
        @player.handle_input(data)
      else
        @connector.handle_input(data)  
      end
    # rescue => e
    #   # We want errors to be raised when Aeon is in test mode.
    #   Aeon.mode == :test ? raise(e) : Aeon.logger.error(e)
    end
  
    # Called when the client disconnects
    def unbind
      @player.logout if @player
    end
  
  
    def login_to_player(player)
      @player = player
      @player.login(self)
      @connector = nil
    end
  
    def reload!
      login_to_player(Aeon::Player.get(@player.id))
    end
  
  
    def disconnect(msg="Goodbye!")
      @player = nil
      display msg
      close_connection_after_writing
    end
  
    def prompt(str)
      send_data "\n#{str}"
    end
  
    def display(str)
      send_data "\n#{str}\n"
    end
  end
end
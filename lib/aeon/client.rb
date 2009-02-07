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
      puts "-- From #{@player || @connector} #{ip_address}:"
      puts "-- " + data.inspect.yellow
      
      benchmark do
        if @player
          @player.handle_input(data)
        else
          @connector.handle_input(data)
        end
      end
    # rescue => e
    #   # We want errors to be raised when Aeon is in test mode.
    #   Aeon.mode == :test ? raise(e) : Aeon.logger.error(e)
    end
  
    # Called when the client disconnects
    def unbind
      @player.logout if @player
      @player = nil
      @connector = nil
    end
  
    # Logs this client into the specified player.
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
    
    def ip_address
      Socket.unpack_sockaddr_in(get_peername)[1]
    end
    
    def benchmark
      start_time = Time.now
      yield
      seconds = Time.now - start_time
      ms = seconds * 1000
      reqs_per_second = 1 / seconds
      puts "-- Time:  %.0fms (%.0f req/s)\n\n" % [ms, reqs_per_second]
    end
  
    def prompt(str)
      send_data "\n#{str}"
    end
  
    def display(str)
      send_data "\n#{str}\n"
    end
  end
end
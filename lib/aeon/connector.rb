# Takes new connections and logs them into a Player
#
# This class implements a pseudo-state machine of dubious usefulness written
# by me. I wanted something that would clarify the states of this class (and
# other state-based classes in the future).
#
# If I decide to keep this functionality, it'll be refactored into a module.

class Aeon::Connector
  attr_reader :current_state
  
  def self.state(state_name, &block)
    @@states ||= []
    @@states << state_name
    define_method("#{state_name}?") { @current_state == state_name }
    
    block.call
  end
  
  def self.on_enter(&block)
    define_method("#{@@states.last.to_s}_on_enter", &block)
  end
  
  def self.on_input(&block)
    define_method("#{@@states.last.to_s}_on_input", &block)
  end
  
  def transition_to(state_name)
    raise "Tried to transition to unknown state: #{@state_name}" unless @@states.include?(state_name)
    @current_state = state_name
    send("#{@current_state}_on_enter")
  end
  
  def handle_input(input)
    send("#{@current_state}_on_input", input.chomp)
  end
  
  
  
  
  
  def initialize(client)
    @client = client
    transition_to :enter_name
  end
  
  state :enter_name do
    on_enter do
      @client.prompt "What is your name, wanderer? > " 
    end
    
    on_input do |name|
      if Aeon::Player.first(:name => name)
        @player_name = name
        transition_to :enter_password
      else
        @client.display("No player found by that name.")
        transition_to :enter_name
      end
    end
  end
  
  state :enter_password do
    on_enter do
      @client.prompt "OK, give me a password for #{@player_name} > "
    end
    
    on_input do |password|
      if @player = Aeon::Player.authenticate(@player_name, password)
        transition_to :logged_in
      else
        @client.display("Password Incorrect.")
        transition_to :enter_name
      end
    end
  end
  
  state :logged_in do
    on_enter do
      @client.login_to_player(@player)
    end
  end
  
end
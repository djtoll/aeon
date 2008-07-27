# Takes new connections and logs them into a Player
#
# This class implements a pseudo-state machine of dubious usefulness written
# by me. I wanted something that would clarify the states of this class (and
# other state-based classes in the future).
#
# If I decide to keep this functionality, it'll be refactored into a module.

class Aeon::Connector
  attr_reader :player
  
  def initialize(connection)
    @client = connection
    transition_to :enter_name
  end
  
  def self.step(step_name, &block)
    @@steps ||= []
    @@steps << step_name
    define_method("#{step_name}?") { @current_step == step_name }
    
    block.call
  end
  
  def self.on_enter(&block)
    define_method("#{@@steps.last.to_s}_on_enter", &block)
  end
  
  def self.on_input(&block)
    define_method("#{@@steps.last.to_s}_on_input", &block)
  end
  
  def transition_to(step_name)
    raise "Tried to transition to unknown step: #{@step_name}" unless @@steps.include?(step_name)
    @current_step = step_name
    send("#{@current_step}_on_enter")
  end
  
  def handle_input(input)
    send("#{@current_step}_on_input", input.chomp)
  end
  
  
  step :enter_name do
    on_enter { @client.prompt "What is your name, wanderer? > " }
    on_input do |input|
      if Aeon::Player.first(:name => input)
        @player_name = input
        transition_to :enter_password
      else
        @client.display("No player found by that name.")
        transition_to :enter_name
      end
    end
  end
  
  step :enter_password do
    on_enter { @client.prompt "OK, give me a password for #{@player_name} > " }
    on_input do |input|
      if @player = Aeon::Player.authenticate(@player_name, input)
        transition_to :logged_in
      else
        @client.display("Password Incorrect.")
        transition_to :enter_name
      end
    end
  end
  
  step :logged_in do
    on_enter { @client.display("Welcome to Aeon, #{@player.name}.") }
  end
  
end
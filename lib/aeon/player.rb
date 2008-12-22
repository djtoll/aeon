# The Player class acts as an interface between the human player and the MUD
# character (Aeon::Character) that he/she controls.

class Aeon::Player
  include DataMapper::Resource

  property :id,         Integer, :serial => true
  property :name,       String
  property :password,   String
  property :created_at, DateTime
  property :updated_at, DateTime  
  
  has 1, :character
  
  # Override DM's table name, which would have been "aeon_players"
  @storage_names[:default] = "players"
  
  
  include Commandable
  
  attr_reader :client
  attr_reader :world
  attr_reader :animated_object
  
  # Entry point for input from the Client. Do some cleanup on the input and
  # react to it.
  def handle_input(str)
    str.strip!
    return prompt if str.empty?
    execute_command(str)
  end
  
  
  # TODO: Encrypt passwords.
  def self.authenticate(name, password)
    first(:name => name, :password => password)
  end
  
  # Animate is the method that actually gives a Player control over a game
  # object (their character by default)
  def animate(object=character)
    @animated_object = object.become_animated(self)
  end
  
  # Stop controlling the currently animated object.
  def deanimate(object=character)
    @animated_object = nil
    object.become_deanimated
  end
  
  def login(client)
    @client.disconnect("This player has been logged in from another connection.") if logged_in?
    @client = client
    @world  = Aeon::World.current_instance
    @world.add_player(self)
    animate
    display "Welcome to Aeon, #{name}."
  end
  
  def logout
    deanimate if @animated_object
    @client.disconnect
    @client = nil
    @world.remove_player(self)
  end
  
  def logged_in?
    @client ? true : false
  end
  
  command :east do
    @animated_object.move(:east)
  end
  command :west do
    @animated_object.move(:west)
  end
  command :north do
    @animated_object.move(:north)
  end
  command :south do
    @animated_object.move(:south)
  end
  
  command :say do |msg|
    @animated_object.say(msg)
  end
  
  command :who do
    msg =  "Online Players:\n"
    msg << "---------------\n"
    msg << @world.players.collect {|p| "#{p.name}\n"}.join
    display msg
  end
  
  command :whoami do
    display "You are #{@name}."
  end
  
  command :ooc do |msg|
    @world.players.each do |p|
      p.display "[OOC] #{name}: #{msg}"
    end
  end
  
  command :quit do
    logout
  end
  
  command :look do
    display @animated_object.room.full_description
  end
  
  command :raise do
    raise "Fake Error, raised by #{name}."
  end
  
  command :eval do |input|
    display(eval(input))
  end
  
    
  # Delegator to Aeon::Client#display
  # We also reprompt after each display unless told otherwise
  def display(str, reprompt=true)
    @client.display(str)
    prompt if reprompt
  end
  
  # Delegator to Aeon::Client#prompt
  # Prompt with +str+ or the default prompt "PlayerName> "
  def prompt(str="#{@name}> ")
    @client.prompt(str)
  end
  
  def reload!
    @client.reload!
    @client = nil
    deanimate if @animated_object
    @world.remove_player(self)
  end

end

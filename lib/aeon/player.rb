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
  
  
  attr_accessor :client
  attr_accessor   :animated_object
  
  
  # TODO: yeah, obviously storing passwords in plain text is a bad idea. This
  # will change.
  def self.authenticate(name, password)
    self.first(:name => name, :password => password)
  end
  
  # Animate is the method that actually gives a Player control over a game
  # object (usually their Character). Commands that have actual effects in the
  # game world will be filtered through whatever object the player is
  # animating.
  def animate(object=self.character)
    raise "Can't animate nil object." if object.nil?
    @animated_object = object
    object.animator  = self
  end
  
  def deanimate(object=self.character)
    @animated_object = nil
    object.animator  = nil
  end

  # Entry point for input from the Client. Do some cleanup on the input and
  # react to it.
  def handle_input(data)
    data = data.strip.chomp
    return prompt if data.empty?
    execute_command(data)
  end
  
  # Searches the list of commands for a matching one and executes it.
  def execute_command(input)
    # Grab the first word as the command, the rest as the args  
    cmd, args = input.split(/\s/, 2)
    # find a list of matching commands
    matches = @@commands.grep(/#{cmd}/)
    unless matches.empty?
      send "cmd_#{matches.first}", args
    else
      display 'Huh?'
    end
  end


  
  # Class method for DSL-ish definition of commands.
  def self.command(command_name, &block)
    @@commands ||= []
    @@commands <<  command_name.to_s
    define_method("cmd_#{command_name.to_s}", &block)
  end
  
  command :who do
    msg =  "Online Players:\n"
    msg << "---------------\n"
    msg << Aeon.world.players.inject('') {|memo, p| memo << "#{p.name}\n"}
    display msg
  end
  
  command :whoami do
    display "You are #{@name}."
  end
  
  command :ooc do |args|
    Aeon.world.players.each do |player|
      player.display "[OOC] TestPlayer: #{args}"
    end
  end
  
  command :quit do
    display "Goodbye!", false
    deanimate
    @client.close_connection_after_writing
  end
  
  command :east do
    @animated_object.move(:east)
  end
  
  command :look do
    display @animated_object.room.full_description
  end 
  
  
    
  # Delegator to Aeon::Client#display
  # We also reprompt after each display unless told otherwise
  def display(str, reprompt=true)
    @client.display(str)
    prompt if reprompt
  end
  
  # Delegator to Aeon::Client#prompt
  def prompt(str=nil)
    str ? @client.prompt(str) : @client.prompt("#{@name}> ")
  end

end

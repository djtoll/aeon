# The Player class acts as an interface between the human player and the MUD
# character (Aeon::Character) that he/she controls.

require 'terminal-table/import'

module Aeon
  class Player
    include DataMapper::Resource

    property :id,         Integer, :serial => true
    property :name,       String
    property :password,   String
    property :created_at, DateTime
    property :updated_at, DateTime  
  
    has 1, :character
  
    # Override DM's table name, which would have been "aeon_players"
    @storage_names[:default] = "players"
  
    attr_reader :animated_object
  
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
      object.become_animated(self)
      @animated_object = object
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
      # puts "#{name} has connected:"
      # puts self.inspect
      # puts @world.inspect
      # puts
      display "Welcome to Aeon, #{name}."
      animate
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
      msg << @world.players.collect {|p| "#{p.name} (#{p.object_id})\n"}.join
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
      @animated_object.look(@animated_object.room)
    end
  
    command :raise do
      raise "Fake Error, raised by #{name}."
    end
  
    command :eval do |input|
      display(eval(input))
    end
    
    command :bulldoze do |direction|
      @animated_object.room.bulldoze(direction, :name => "A Bulldozed Room", :description => "It's all empty in here!")
      @animated_object.move(direction.to_sym)
    end
    
    command :summon do |summoned_name|
      if player = @world.players.detect {|p| p.name == summoned_name}
        player.animated_object.to_room(
          "Suddenly, a glowing red portal opens and #{player.name} is sucked through!",
          "You are sucked through the ether toward #{name}."
        )
        animated_object.to_room(
          "Suddenly, #{player.name} appears through a glowing red portal, summoned by #{name}.",
          "You summon #{player.name} through your magical portal."
        )
        player.animated_object.set_room(@animated_object.room)
      else
        display "No player found by that name."
      end
    end
    
    command :reboot do
      Loader.reboot!
    end
    
    command :objects do
      t1 = table ['Class', 'Count']
      [Aeon::World, Aeon::Room, Aeon::Player, Aeon::Character].each do |klass|
        t1 << [klass.to_s, ObjectSpace.count(klass)]
      end
      
      t2 = table ["Class", "Object", "ID", "to_s"]
      [@animated_object, @animated_object.room].each do |obj|
        t2 << [obj.class.to_s, obj.object_id, obj.id, obj.to_s]
      end
      
      display("#{t1}\n#{t2}")
    end
  
    command :reload do
      @animated_object.room.reload
      display "Reloaded Room #{@animated_object.room}"
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
    end
  end
end

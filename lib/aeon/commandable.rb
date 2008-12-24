module Aeon
  module Commandable
    def self.included(klass)
      # Single quotes turn off string interpolation for heredocs.
      klass.instance_eval <<-'INSTANCE_EVAL'
        @commands = []
      
        def self.commands
          @commands
        end
      
        def self.command(command_name, &block)
          @commands << command_name.to_s
          define_method("cmd_#{command_name}", block)
        end
      INSTANCE_EVAL
    end
  
    # Searches the list of commands for a matching one and executes it.
    def execute_command(input)
      # Grab the first word as the command, the rest as the args
      cmd, args = input.split(/\s/, 2)
    
      match = self.class.commands.grep(/^#{cmd}/i).first
      match ? send("cmd_#{match}", args) : display("Huh?")
    end
  end
end
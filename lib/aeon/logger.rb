module Aeon
  class Logger
  
    # Formats Errors into a pretty output.
    def error(e)
      msg = "#{e.message}\n\t#{e.backtrace}"
      world = World.current_instance
      world ? world.broadcast("[ERROR] #{msg}") : puts(msg)
    end
  
    def debug(msg)
      World.current_instance.broadcast("[DEBUG] #{msg}")
    end
    
  end
end
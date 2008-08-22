class Aeon::Logger
  
  # Formats Errors into a pretty output.
  def error(e)
    short_trace = e.backtrace[0,3]
    short_trace << "...#{e.backtrace.length - 4} more levels..."
    msg = [e.message, short_trace].join("\n\t")
    Aeon.world.broadcast("[ERROR] #{msg}")
  end
  
  def debug(msg)
    Aeon.world.broadcast("[DEBUG] #{msg}")
  end
  
end
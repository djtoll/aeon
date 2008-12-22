class Aeon::Logger
  
  # Formats Errors into a pretty output.
  def error(e)
    short_trace = e.backtrace
    # short_trace = e.backtrace[0,3]
    # short_trace << "...#{e.backtrace.length - 4} more levels..."
    msg = [e.message, short_trace].join("\n\t")
    Aeon::World.current_instance.broadcast("[ERROR] #{msg}")
  end
  
  def debug(msg)
    Aeon::World.current_instance.broadcast("[DEBUG] #{msg}")
  end
  
end
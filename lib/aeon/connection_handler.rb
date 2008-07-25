# This is the module which gets mixed into EventMachine::Connection when the
# server starts. EventMachine::Connection provides three hooks for us to
# override: post_init, receive_data, and unbind.
module Aeon::ConnectionHandler
  # Called when the client connects
  def post_init
    
  end
  
  # Called when we receive data from the client
  def receive_data(data)
    
  end
  
  # Called when the client disconnects
  def unbind
    
  end

end
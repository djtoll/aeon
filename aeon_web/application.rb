Merb::Router.prepare do
  match('/').to(:controller => "rooms", :action =>'index')
  resources :rooms
  # default_routes
end


class AeonWeb < Merb::Controller
end

class Rooms < AeonWeb
  def index
    render
  end
  
  def edit
    @room = Aeon::Room.get(params[:id])
    render
  end
  
  def update
    @room = Aeon::Room.get(params[:id])
    if @room.update_attributes(params[:room])
      clear_cache(params[:id])
      redirect url(:edit_room, @room)
    else
      edit
    end
  end
  
  private
  
  # This sends the ID of the room to the AdminServer side of Aeon so that it
  # can reload it from the database. There may be a better way to do this, but
  # this seems the most straightforward. DRb seems like overkill.
  def clear_cache(id)
    conn = TCPSocket.new('127.0.0.1', 5001)
    conn.send(id, 0)
  end
end

module Merb
  module RoomsHelper
    def td_class(room)
      if room
        css_class = "room"
        css_class << " current" if room.id == params[:id].to_i
        css_class << " #{room_exits(room)}"
      else
        css_class = "blank"
      end
      css_class
    end
    
    def room_exits(room)
      exits = ""
      exits << "n" if room.north_id
      exits << "e" if room.east_id
      exits << "s" if room.south_id
      exits << "w" if room.west_id
      exits
    end
  end
end
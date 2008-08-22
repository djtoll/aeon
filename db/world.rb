@character = Aeon::Character.create(
  :name => 'Ethrin'
)

@player = Aeon::Player.create(
  :name => 'Ethrin',
  :password => 'secret',
  :character => @character
)
  
@room_start = Aeon::Room.create(
  :name => "A Test Room",
  :description => "You are in the test room!"
)

@room_east = Aeon::Room.create(
  :name => "Another Test Room",
  :description => "The eastern test room"
)

@room_start.link_with(@room_east, :east)
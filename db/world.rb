# This should create an associated Character with the same name automatically.
player1 = Aeon::Player.create(
  :name => 'Ethrin',
  :password => 'secret'
)
  
room1 = Aeon::Room.create(
  :name => "A Test Room",
  :description => "You are in the test room!"
)
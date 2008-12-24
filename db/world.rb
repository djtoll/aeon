require AEON_ROOT + '/spec/factory'

Factory.create(:player, :name => "Ethrin")
Factory.create(:player, :name => "Halv")

# r1 – r2 – r5
#       |   |
#      r3 – r4

r1 = Aeon::Room.create(
  :name        => "r1",
  :description => "You are in the test room!"
)

r2 = r1.bulldoze(:east,
  :name        => "r2",
  :description => "The r2 room OMG!"
)

r3 = r2.bulldoze(:south,
  :name        => "r3",
  :description => "Welcome to r3"
)

r4 = r3.bulldoze(:east,
  :name        => "r4",
  :description => "OH HAI I'm r4"
)

r5 = r4.bulldoze(:north,
  :name        => "r5",
  :description => "I'm the very last room! wewt."
)

r5.bulldoze(:west)
require File.dirname(__FILE__) + "/../lib/aeon"
require AEON_ROOT + '/spec/factory'

DataMapper.auto_migrate!

Factory.create(:player, :name => "Ethrin")
Factory.create(:player, :name => "Halv")

Aeon::Room.create(
  :name        => "The Square",
  :description => "The illustrious fountain of whatever."
)

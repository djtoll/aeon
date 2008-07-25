class Aeon::Player
  include DataMapper::Resource

  property :id,   Integer, :serial => true
  property :name, String

  def initialize(*args)
    super(*args)
  end
end

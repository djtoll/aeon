require 'spec/spec_helper'
require 'db/world'

@client = MockClient.new
@client.login_to_player(@player)

def i(data)
  @client.receive_data(data)
end

char = @player.animated_object

puts char.room
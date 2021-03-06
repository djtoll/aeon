# Monkey-patch for DataMapper that will make the IdentityMap global.
# Hazardous side-effects TBD :)


# Normally, the Identity Maps are held within an instance variable of each
# Repository instance. Repositories are instantiated on every DB call. So to
# create a "global" set of Identity Maps, I'm simply storing them inside a
# constant instead of an instance variable.
#
# From what I understand, the reason that DM doesn't keep a global IdentityMap
# by default is that the IdentityMap will grow until it consumes all available
# memory. This makes plenty of sense. However, in the game, ideally I *want*
# everything in memory at the same time. ...I think.
#
# The other option is to use a "Weak Hash" for the Identity Maps. Weak Hashes
# will allow the garbage collector to free key/values that are no longer
# referenced by anything but the Weak Hash. Unfortunately, there doesn't seem
# to be a solid Weak Hash implementation for Ruby.
#
module DataMapper
  class Repository
    IDENTITY_MAPS = {}
    
    def self.reset_identity_maps!
      IDENTITY_MAPS.replace({})
    end
    
    # Before:
    #
    #   def identity_map(model)
    #     @identity_maps[model] ||= IdentityMap.new
    #   end
    #
    # "Global" Identity Map:
    #
    def identity_map(model)
      IDENTITY_MAPS[model] ||= IdentityMap.new
    end
    
  end
end

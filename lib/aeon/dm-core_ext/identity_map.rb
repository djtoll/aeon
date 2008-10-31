# Monkey-patch for DataMapper that will make the IdentityMap global.
# Hazardous side-effects TBD :)


# Normally, the Identity Maps are held within an instance variable of each
# Repository instance. Repositories are instantiated on every DB call. So to
# create a "global" set of Identity Maps, I'm simply storing them inside a
# class variable instead of an instance variable.
#
# From what I understand, the reason that DM doesn't keep a global IdentityMap
# by default is that the IdentityMap will grow until it consumes all available
# memory. This makes plenty of sense. However I'm hoping that this won't
# affect my game since ideally I *want* everything in memory at the same time.
#
# The other option is to use a "Weak Hash" for the Identity Maps. Weak Hashes
# will allow the garbage collector to delete objects that are no long
# referenced by anything but the Weak Hash. Unfortunately, there doesn't seem
# to be a solid Weak Hash implementation for Ruby, I think due to the GC's
# funky support for finalizers.

module DataMapper
  class Repository
    # Create the class variable
    @@identity_maps = {}
    
    def identity_map(model)
      @@identity_maps[model] ||= IdentityMap.new
    end

    # Before monkey patch:
    #
    #   def identity_map(model)
    #     @identity_maps[model] ||= IdentityMap.new
    #   end
    #
  end
end

module Aeon  
  # Aeon::Reloader is for observing when certain files change, and using
  # Kernel.load to reload the source file. This is used when the Aeon server
  # is started in development mode, so that source files are reloaded on the
  # fly without having to reboot the server, similar to the development
  # servers in Rails or Merb.
  #
  # In fact, I borrowed stuff from Merb's bootloader. One thing I didn't take
  # from Merb's code however is how it keeps track of what Constants a source
  # file introduces into the ObjectSpace -- so that it can unset them when a
  # file is reloaded. This means that Aeon's Reloader throws "already
  # initialized constant" warnings when a file is reloaded that contains any
  # Constants.
  #
  # I removed this feature because, for reasons that aren't quite clear to me
  # at the moment, objects already instantiated will not use their class's
  # updated code when the class's constant is unset before the reload. By not
  # unsetting the constants, existing objects will use the reloaded code
  # beautifully.
  #
  # This obviously won't be useful in all scenerios. Certain code changes are
  # just going to require a server restart so objects can be reinstantiated.
  class Reloader
    MTIMES = {} # Keeps track of files we're observing and their last modification time.

    # Just a convenience method for setting up which files can be observed.
    # Passes self to the given block so that observe can be called on some files.
    def self.observe_files(&block)
      yield self
    end
    
    # Adds the given file (minus the .rb) to be observed by the reloader.
    # Files observed will be checked for changes every second.
    def self.observe(file)
      MTIMES[file] = File.mtime("lib/#{file}.rb")
    end
    
    # Calls Kernel.load on +file+ and updates its modification date.
    def self.reload_file(file)
      Aeon.logger.debug "Reloading #{file}..."
      Kernel.load "#{file}.rb"
      MTIMES[file] = File.mtime("lib/#{file}.rb")
    end
  
    # Starts a new thread that repeats the passed block at the specified interval.
    class TimedExecutor
      def self.every(seconds, &block)
        Thread.abort_on_exception = true
        Thread.new do
          loop do
            sleep( seconds )
            block.call
          end
          Thread.exit
        end
      end
    end
    
    # Start the Reloader to begin watching for changed files.
    def self.run
      puts "Aeon::Reloader is observing these files:"
      MTIMES.each {|file, mtime| puts file}
      TimedExecutor.every(1) { reload }
    end
    
    # Checks all the files we're observing to see if their modification time
    # has changed.
    def self.reload
      MTIMES.each do |file, mtime|
        next if mtime == File.mtime("lib/#{file}.rb")
        reload_file(file)
      end
    end
    
  end # class Reloader
end # module Aeon

module Aeon  
  # Aeon::Reloader is for reloading classes when the server is running in
  # development mode much like Rails or Merb. In fact, this code was mostly
  # borrowed from Merb.
  #
  # However, it turns out that this was a bad idea, and it won't work without
  # a lot of hacking. This is because I realized that to properly "reload a
  # class", you have to use remove_const to unset the class constant, and
  # *then* use Kernel.load to reload the source file. The problem is that when
  # you use remove_const, objects that are already instantiated that belong to
  # the reloaded class will *not* reflect the new changes.
  #
  # If you don't use remove_const first, as I'm doing here at the moment, you
  # are effectively just reopening the class definition and adding or
  # overwriting existing methods. This tends to break things. Like DataMapper.
  # However, existing objects do reflect the changes since their class still
  # refers to the same object_id, unlike when remove_const is used.
  #
  # The hacking that would make this work involves walking the ObjectSpace and
  # somehow "reloading" the affected objects into their new class.
  #
  # See: http://moourl.com/q4gr5 for a post to Ruby-Talk I made about it.
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
      $LOADED_FEATURES.delete("#{file}.rb")
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

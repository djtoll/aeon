module Aeon  
  class Loader
    MTIMES  = {} # Files we're observing and their last modification time.
    CLASSES = {} # Files we're observing and the classes that they define.
    
    # Just a convenience method for setting up which files can be observed.
    # Yields this class.
    def self.observe_files
      yield self
    end
    
    # Adds the given file (minus the .rb) to be observed by the reloader.
    # Files observed will be checked for changes every second.
    def self.load(file)
      MTIMES[file] = File.mtime("lib/#{file}.rb")
      klasses = ObjectSpace.classes.dup
      Kernel.load "#{file}.rb"
      CLASSES[file] = ObjectSpace.classes - klasses
    end
    
    def self.reload_file(file)
      Aeon.logger.debug "Reloading #{file}..."

      begin      
        remove_constants_in_file(file)
        Aeon::Loader.load file
      rescue SyntaxError, ArgumentError => e
        Aeon.logger.debug "Cannot load #{file} because of syntax error: #{e.message}"
      ensure
        MTIMES[file] = File.mtime("lib/#{file}.rb")
      end
    end
    
    # Start the Reloader to begin watching for changed files.
    def self.run
      puts "Aeon::Reloader is observing these files:"
      pp MTIMES
      pp CLASSES
      TimedExecutor.every(1) { reload }
    end
    
    # Checks all the files we're observing to see if their modification time
    # has changed.
    def self.reload
      files = []
      MTIMES.each do |file, mtime|
        files << file unless mtime == File.mtime("lib/#{file}.rb")
      end
      unless files.empty?
        old_world = Aeon::World.current_instance
        files.each {|f| reload_file(f)}
        Aeon::World.new
        DataMapper::Repository.reset_identity_maps!
        old_world.players.each {|p| p.reload!}
        GC.start
      end
    end
    
    def self.remove_constants_in_file(file)
      CLASSES[file].each do |const| 
        parts = const.to_s.split("::")
        base = parts.size == 1 ? Object : Object.full_const_get(parts[0..-2].join("::"))
        object = parts[-1].to_s
        base.send(:remove_const, object)
      end
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
    
  end # class Loader
end # module Aeon

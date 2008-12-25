module Aeon  
  class Loader
    MTIMES  = {} # Files we're observing and their last modification time.
    CLASSES = [] # Files we're observing and the classes that they define.
    
    # Just a convenience method for setting up which files can be observed.
    # Yields this class.
    def self.observe_files
      klasses = ObjectSpace.classes.dup
      yield self
      @loaded_classes = ObjectSpace.classes - klasses
    end
    
    def self.reboot!
      old_world = Aeon::World.current_instance
      reload_files
      Aeon::World.new
      DataMapper::Repository.reset_identity_maps!
      old_world.players.each {|p| p.reload!}
      old_world.players = []
      GC.start
    end
    
    def self.reload_files
      begin
        @loaded_classes.each { |klass| remove_constant(klass) }
        @files.each do |file| 
          Kernel.load "#{file}.rb"
        end
      rescue SyntaxError, ArgumentError => e
        Aeon.logger.debug "Cannot load #{file} because of syntax error: #{e.message}"
      ensure
        @last_mtime = Time.now
      end
    end
    
    # Adds the given file (minus the .rb) to be observed by the reloader.
    # Files observed will be checked for changes every second.
    def self.load(file)
      # MTIMES[file] = File.mtime("lib/#{file}.rb")
      @last_mtime = File.mtime("lib/#{file}.rb")
      @files ||= []
      @files << file
      Kernel.load "#{file}.rb"
    end

    def self.remove_constant(const)
      parts = const.to_s.split("::")
      base = parts.size == 1 ? Object : Object.full_const_get(parts[0..-2].join("::"))
      object = parts[-1].to_s
      base.send(:remove_const, object)
    end
    
    
    # Start the Reloader to begin watching for changed files.
    def self.run
      TimedExecutor.every(1) do 
        @files.each do |file|
          reboot! and break if File.mtime("lib/#{file}.rb") > @last_mtime
        end
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

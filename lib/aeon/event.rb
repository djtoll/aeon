module Aeon
  class Event
    def initialize(opts)
      @instigator = opts[:instigator]
      @target     = opts[:target]
      @message    = opts[:message]
      @to_self    = opts[:to_self]
      
      propogate
    end
    
    def propogate
      @target.objects.each do |obj|
        obj.display(@message) unless obj == @instigator
      end
      @instigator.display(@to_self) if @to_self
    end
  end
  
  class VisualEvent < Event
  end
  
  class AudibleEvent < Event
  end
end
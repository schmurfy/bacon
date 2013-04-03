
module Bacon
  module DisableGC
    def run(*)
      if toplevel
        GC.disable
      end
      
      super
      
      if toplevel
        GC.enable()
        GC.start()
      end
    end
    
  end

  Context.send(:include, DisableGC)
end

puts "GC disabled during tests"

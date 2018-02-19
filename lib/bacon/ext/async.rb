require 'async'



module Bacon
  module AsyncSpec
    class <<self
      attr_accessor :top_task
    end
    
    def wakeup
      if @waiting_task
        t = @waiting_task
        
        @waiting_task.reactor.after(0) do
          t.fiber.resume()
        end
        
        @waiting_task = nil
      end
    end
    
    def cancel_timer()
      if @timeout_timer
        @timeout_timer.cancel()
        @timeout_timer = nil
      end
    end
    
    def wait(timeout = 0.1)
      cancel_timer()
      
      @waiting_task = Async::Task.current
      @timeout_timer = @waiting_task.reactor.after(timeout) do
        wakeup()
      end
      
      Async::Task.yield()
      # Fiber.yield()
      
    ensure
      cancel_timer()
      @waiting_task = nil
    end
    
    
    def done
      wakeup()
    end
    
    # def run_requirement(title, *args)
    #   p [:RUN_START, title]
    #   super(title, *args)
    #   p [:RUN_END]
    # end
    
    def run(*)
      if AsyncSpec.top_task && (AsyncSpec.top_task == Async::Task.current?)
        super
      else
        Async::Reactor.run do |task|
          task.async do |reactor|
            AsyncSpec.top_task = Async::Task.current?
            begin
              super
              reactor.stop()
            ensure
              AsyncSpec.top_task = nil
            end
          end
        end
      end
    end
    
  end
  
  Context.send(:include, AsyncSpec)
end

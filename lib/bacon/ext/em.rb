
require 'fiber'
require 'eventmachine'

#
# This module allows you to run your specs inside an eventmachine loop
# check examples/em_spec.rb for usage.
# 
# Be aware that it does not work like the em-spec gem, no timeout error will
# ever be raised.
# 
module Bacon
  module EMSpec # :nodoc:

    def wait(timeout = 0.1, &block)
      @waiting_fiber = Fiber.current
      EM::cancel_timer(@timeout)
      @timeout = EM::add_timer(timeout){ @waiting_fiber.resume }
      Fiber.yield
      
      @waiting_fiber = nil
      
      block.call if block
    end
    
    def done
      EM.cancel_timer(@timeout)
      @waiting_fiber.resume if @waiting_fiber
    end
    
    def run(*)
      subcontext =  EM::reactor_running?
      if subcontext
        super
      else
        EM::run do
          Fiber.new do
            super
            EM::stop_event_loop
          end.resume
        end
        
      end
    end

  end
  
  Context.send(:include, EMSpec)
end


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
    class << self
      attr_accessor :context_fiber
    end
    
    def wakeup
      # this should be enough but for some reason the reactor
      # idles for 20 seconds on EM::stop before really exiting
      # @waiting_fiber.resume
      
      if @waiting_fiber
        EM::next_tick { @waiting_fiber.resume }
      end
    end
    
    def wait(timeout = 0.1, &block)
      @waiting_fiber = Fiber.current
      EM::cancel_timer(@timeout)
      @timeout = EM::add_timer(timeout, &method(:wakeup))
      
      Fiber.yield
      
      @waiting_fiber = nil
      
      block.call if block
    end
    
    def done
      EM.cancel_timer(@timeout)
      wakeup
    end
    
    def new_fiber(&block)
      Fiber.new(&block)
    end
    
    def run(*)
      if EMSpec.context_fiber == Fiber.current
        super
      else
        EM::run do
          EM::error_handler do |err|
            ::Bacon::store_error(err, "(EM Loop)")
          end
          
          new_fiber do
            EMSpec.context_fiber = Fiber.current
            begin
              super
              EM::stop_event_loop
            ensure
              EMSpec.context_fiber = nil
            end
          end
          
        end
        
      end
    end

  end
  
  Context.send(:include, EMSpec)
end

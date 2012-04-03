
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
  class Context
    def with_eventmachine!
      (class << self; self; end).send(:include, EMSpec)
    end
  end
  
  module EMSpec # :nodoc:

    def wait(timeout = 0.1, &block)
      waiting_fiber = Fiber.current
      EM::cancel_timer(@timeout)
      @timeout = EM::add_timer(timeout){ waiting_fiber.resume }
      Fiber.yield
      
      block.call if block
    end
    
    def done
      EM.cancel_timer(@timeout)
      EM.stop
    end

    def describe(*, &block)
      super do
        with_eventmachine!
        block.call
      end
    end

    def run_requirement(desc, spec)
      raise "block required" unless block

      @timeout_interval = nil

      EM.run do
        Fiber.new do
          super
          done
        end.resume
      end
    end

  end
  
  
end

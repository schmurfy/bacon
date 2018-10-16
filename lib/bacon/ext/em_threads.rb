
require 'thread'
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
      attr_accessor :context_thread
    end
    
    def wakeup
      # this should be enough but for some reason the reactor
      # idles for 20 seconds on EM::stop before really exiting
      # @waiting_thread.resume
      
      if @waiting_thread
        EM::next_tick { @waiting_thread.wakeup }
      end
    end
    
    def wait(timeout = 0.1, &block)
      @waiting_thread = Thread.current
      EM::cancel_timer(@timeout)
      @timeout = EM::add_timer(timeout, &method(:wakeup))
      
      sleep
      
      @waiting_thread = nil
      
      block.call if block
    end
    
    def done
      EM.cancel_timer(@timeout)
      wakeup
    end
    
    def new_thread(&block)
      Thread.new(&block)
    end
    
    def run(*)
      if EMSpec.context_thread == Thread.current
        super
      else
        EM::run do
          EM::error_handler do |err|
            ::Bacon::store_error(err, "(EM Loop)")
          end
          
          new_thread do
            EMSpec.context_thread = Thread.current
            begin
              super
              EM::stop_event_loop
            ensure
              EMSpec.context_thread = nil
            end
          end
          
        end
        
      end
    end

  end
  
  Context.send(:include, EMSpec)
end

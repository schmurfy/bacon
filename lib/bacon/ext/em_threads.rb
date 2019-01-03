module Bacon
  module Threaded
    class << self
      attr_accessor :context_thread
    end

    def run(*)
      if Threaded.context_thread == Thread.current
        super
      else
        EM.run do
          EM.defer do
            Threaded.context_thread = Thread.current
            begin
              super
            ensure
              EM::stop_event_loop()
            end
          end

        end
      end
    end

  end

  Context.send(:prepend, Threaded)
end

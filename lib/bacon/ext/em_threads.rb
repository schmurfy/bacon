module Bacon
  module Threaded

    def run(*)
      if Thread.main == Thread.current
        EM.next_tick do
          Thread.new do
            sleep(0.1)
            super
            EM::stop_event_loop()
          end

        end
      else
        super
      end
    end

  end

  Context.send(:prepend, Threaded)
end

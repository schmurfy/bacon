require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'
require 'bacon/ext/async'

Bacon.summary_on_exit

def run_something_later(&block)
  Async::Task.current.reactor.after(0.1) do
    block.call("something")
  end
end

describe 'AsynchronousSpec' do  
  before do
    # Eventmachine is running, yeah !
    # Async::Task.current.reactor.stopped.should == false
  end
  
  it 'ends immediately' do
    # Async::Task.current.reactor.stopped.should == false
    1.should == 1
    # without action EM::stop is called after our code
  end
  
  it 'requires time (simple)' do
    executed = false

    Async::Task.current.reactor.after(0.1) do
      executed = true
    end

    wait(0.2)
    executed.should == true
  end
  
  
  it 'requires time (less simple)' do
    v = 1
    Async::Task.current.reactor.after(0.1){ v = 2 }
    
    # wait 0.2s and then execute the passed block
    wait(0.2)
    v.should == 2
  end
  
  # if done is called the test ends early
  # but the block passed to wait is till called
  should 'end early' do
    v = 1
    Async::Task.current.reactor.after(0.2) do
      v+= 1
      done
    end
    
    Async::Task.current.reactor.after(0.3){ v = 3 }
    wait(1)
    v.should == 2
  end
  
end

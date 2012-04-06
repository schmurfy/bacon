require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'
require 'bacon/ext/em'

Bacon.summary_on_exit

def run_something_later(&block)
  EM::add_timer(0.1) do
    block.call("something")
  end
end

describe 'AsynchronousSpec' do  
  before do
    # Eventmachine is running, yeah !
    EM::reactor_running?.should == true
  end
  
  it 'ends immediately' do
    EM::reactor_running?.should == true
    1.should == 1
    # without action EM::stop is called after our code
  end
  
  it 'requires time (simple)' do
    # suppose this method do something
    # 0.1s after the call
    run_something_later do |s|
      s.should == "something"
    end
    
    wait(0.2)
  end
  
  
  it 'requires time (less simple)' do
    v = 1
    EM::add_timer(0.2){ v = 2 }
    
    # wait 0.2s and then execute the passed block
    wait(0.2){ v.should == 2 }
  end
  
  # if done is called the test ends early
  # but the block passed to wait is till called
  should 'end early' do
    v = 1
    EM::add_timer(0.2){ v+= 1; done }
    EM::add_timer(0.3){ v = 3 }
    wait(1){ v.should == 2 }
  end
  
end

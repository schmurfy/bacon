require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'
require 'bacon/ext/em'

Bacon.summary_on_exit


describe 'Main context' do
  with_eventmachine!
  
  before do
    # EM::reactor_running?.should == true
    @var = 1
  end
  
  should 'pass' do
    2.should == 2
  end
  
  describe 'sub context 1' do
    before do
      @var += 2
    end
    
    should 'pass' do
      2.should == 2
      @var.should == 3
    end
  end
end

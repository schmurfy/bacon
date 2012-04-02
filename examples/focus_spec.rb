require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'

Bacon.summary_on_exit

# define this if you want to be sure you are
# executing every tests.
# (I use this in my "rake test" task)
# 
# Bacon.allow_focused_run = false

describe 'FocusSpec' do
  focus "could do something"
    
  it 'does nothing' do
    1.should == 1
  end
  
  it 'also does nothing' do
    1.should == 1
  end
  
  it 'could do something' do
    1.should == 1
  end
  
end

describe 'FocusContextSpec' do
  focus_context "sub context"
    
  it 'does nothing' do
    1.should == 1
  end
  
  describe 'sub context' do  
    it 'also does nothing' do
      2.should == 1
    end
    
    it 'does nothing once more but pass' do
      1.should == 1
    end
  end
  
  it 'could do something' do
    1.should == 1
  end
  
end

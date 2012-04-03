require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'
require 'bacon/ext/mocha'

Bacon.summary_on_exit

def call_it(target)
  target.do_something(42)
end

describe 'MochaSpec' do
  before do
    @m = mock()
  end
  
  it 'should call method on mock' do
    @m.expects(:do_something).with(anything())
    call_it(@m)
  end
  
end

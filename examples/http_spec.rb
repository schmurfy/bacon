require 'rubygems'

$LOAD_PATH.unshift << File.expand_path('../../lib/', __FILE__)

require 'bacon'
require 'bacon/ext/em'
require 'bacon/ext/http'

Bacon.summary_on_exit

class App
  def call(env)
    [200, {}, [env['REQUEST_PATH']]]
  end
end

describe 'Rack app 1' do
  before do
    start_server(App.new)
  end
  
  should 'respond to http requests' do
    answer = nil
    http_request(:get, '/something') do |r|
      answer = r.response[1..-1]
    end
    
    answer.should == 'something'
  end
end


describe 'Rack app 2' do
  before do
    start_server do
      run App.new
    end
  end
  
  should 'respond to http requests' do
    answer = nil
    http_request(:get, '/something') do |r|
      answer = r.response[1..-1]
    end
    
    answer.should == 'something'
  end
end

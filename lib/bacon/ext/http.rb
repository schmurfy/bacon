
gem 'em-http-request'
gem 'thin'
require 'em-http-request'
require 'thin'

module Bacon
  module HTTPHelpers
    @@servers = []
    
    def start_server(rack_app = nil, &block)
      $bacon_http_port ||= 11000
      $bacon_http_port+= 1
      
      if rack_app && rack_app.respond_to?(:call)
        block = proc{
          run rack_app
        }
      end
      
      Thin::Logging.silent = true
      
      server = Thin::Server.new('127.0.0.1', $bacon_http_port, signals: false, &block)
      server.start
      
      @@servers << server
    end
    
    def stop_servers()
      @@servers.each{|s| s.stop() }
      @@servers = []
    end
    
    def http_url(path)
      "http://127.0.0.1:#{$bacon_http_port}#{path}"
    end
    
    def http_request(method, path, args = {}, &block)
      headers = args.delete(:headers) || {}
      body = args.delete(:body)
      params = args.delete(:params) || {}
      
      request_data = {:path => path, :query => params, :head => headers, :body => body}
      
      req = EM::HttpRequest.new("http://127.0.0.1:#{$bacon_http_port}#{path}").send(method, request_data)
      req.callback(&block)
      req
    end
    
    def check_http_response_status(req, expected, body_regexp = nil)
      status = req.response_header.status
      unless status == expected
        raise Bacon::Error.new(:failed, "expected status was #{expected}, got #{status} : #{req.response}")
      end

      if body_regexp
        body_ok = false
        if body_regexp.is_a?(Regexp)
          body_ok = (req.response =~ body_regexp)
        else
          body_ok = (req.response == body_regexp)
        end
        
        unless body_ok
          raise Bacon::Error.new(:failed, "body does not match\n\texpected\t\"#{body_regexp}\"\n\tgot\t\t\"#{req.response}\"")
        end
      end

      # just to avoid empty specification error
      status.should == expected
    end
    
  end
  
  Context.send(:include, HTTPHelpers)
end

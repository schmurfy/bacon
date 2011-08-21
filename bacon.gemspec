
require File.expand_path('../lib/bacon/version', __FILE__)

Gem::Specification.new do |s|
  s.name            = "bacon"
  s.version         = Bacon::VERSION
  s.platform        = Gem::Platform::RUBY
  s.summary         = "a small RSpec clone"

  s.description = <<-EOF
Bacon is a small RSpec clone weighing less than 350 LoC but
nevertheless providing all essential features.

http://github.com/chneukirchen/bacon
  EOF

  s.files           = `git ls-files`.split("\n")
  s.bindir          = 'bin'
  s.executables     << 'bacon'
  s.require_path    = 'lib'
  s.extra_rdoc_files = ['README', 'RDOX']
  s.test_files      = []

  s.author          = 'Christian Neukirchen'
  s.email           = 'chneukirchen@gmail.com'
  s.homepage        = 'http://github.com/chneukirchen/bacon'
end

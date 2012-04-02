# encoding: utf-8
require "bundler/gem_tasks"


desc "Run all the tests"
task :default => [:test]

desc "Generate RDox"
task "RDOX" do
  sh "bin/bacon -Ilib --automatic --specdox >RDOX"
end

desc "Run all the tests"
task :test do
  ruby "bin/bacon -Ilib --automatic --quiet"
end




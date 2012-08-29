# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "kindle/version"

Gem::Specification.new do |s|
  s.name        = "kindle"
  s.version     = Kindle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Petty"]
  s.email       = ["matt@kizmeta.com"]
  s.homepage    = ""
  s.summary     = %q{Manage your kindle highlights with ruby}
  s.description = %q{Manage your kindle highlights with ruby}

  s.rubyforge_project = "kindle"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency "nokogiri"
  s.add_dependency "highline"
  s.add_dependency "mechanize"
end

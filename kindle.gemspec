# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require_relative "lib/kindle"

Gem::Specification.new do |s|
  s.name        = "kindle"
  s.version     = Kindle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Petty"]
  s.email       = ["matt@kizmeta.com"]
  s.homepage    = "https://github.com/lodestone/kindle"
  s.summary     = %q{Manage your kindle highlights with ruby, output in JSON, Markdown, and CSV formats}
  s.description = %q{Manage your Amazon Kindle highlights: Sync and cache to an ActiveRecord database and output in various formats}

  s.rubyforge_project = "kindle"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dh_api/version"

Gem::Specification.new do |s|
  s.name        = "dh_api"
  s.version     = DhApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rui Andrada"]
  s.email       = ["shingonoide@gmail.com"]
  s.homepage    = "http://shingonoide.barradev.com"
  s.summary     = %q{Ruby gem and command line to access Dreamhost's API through json}
  s.description = %q{I need a library to workout with Dreamhost's API, and found Dreamy but seems to be outdated.
                     So I trying to make my own gem to trying to get better and using json
                    }

  s.rubyforge_project = "dh_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

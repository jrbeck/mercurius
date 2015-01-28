# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mercurius/version"

Gem::Specification.new do |s|
  s.name            = 'mercurius'
  s.version         = Mercurius::VERSION
  s.authors         = ["John Beck"]
  s.email           = ["jbeck@live.com"]

  s.homepage        = "https://github.com/jrbeck/mercurius"
  s.summary         = %q{Send push notifications to mobile devices through native services}
  s.description     = <<-DESC
                        This gem is a wrapper to send push notifications to devices through native push services.
                      DESC

  s.rubyforge_project = "mercurius"

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.require_paths = ["lib"]

  s.add_dependency 'httparty'
  s.add_dependency 'json'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mb/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = [
    "Jamie Winsor",
    "Jesse Howarth",
    "Justin Campbell",
    "Michael Ivey",
    "Cliff Dickerson",
    "Andrew Garson",
    "Kyle Allan",
    "Josiah Kiehl",
  ]
  s.email         = [
    "jamie@vialstudios.com",
    "jhowarth@riotgames.com",
    "justin@justincampbell.me",
    "michael.ivey@riotgames.com",
    "cdickerson@riotgames.com",
    "agarson@riotgames.com",
    "kallan@riotgames.com",
    "jkiehl@riotgames.com",
  ]
  s.description   = %q{An orchestrator for Chef}
  s.summary       = s.description
  s.homepage      = "https://github.com/RiotGames/motherbrain"
  s.license       = "Apache 2.0"

  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(spec|features)/})
  s.name          = "motherbrain"
  s.require_paths = ["lib"]
  s.version       = MotherBrain::VERSION
  s.required_ruby_version = ">= 1.9.3"

  s.add_dependency 'celluloid', '~> 0.15.1'
  s.add_dependency 'dcell', '~> 0.15.0'
  s.add_dependency 'reel', '0.4.0'
  s.add_dependency 'reel-rack', '~> 0.0.2'
  s.add_dependency 'grape', '~> 0.5.0'
  s.add_dependency 'net-ssh'
  s.add_dependency 'net-sftp'
  s.add_dependency 'solve', '>= 0.4.4'
  s.add_dependency 'ridley', '~> 1.6.0'
  s.add_dependency 'thor', '~> 0.18.0'
  s.add_dependency 'faraday'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'multi_json'
  s.add_dependency 'fog', '~> 1.10.0'
  s.add_dependency 'json', '>= 1.8.0'
  s.add_dependency 'pry', '= 1.0.0.pre1'
  s.add_dependency 'buff-config', '~> 0.1'
  s.add_dependency 'buff-extensions', '~> 0.5'
  s.add_dependency 'buff-platform', '~> 0.1'
  s.add_dependency 'buff-ruby_engine', '~> 0.1'
end

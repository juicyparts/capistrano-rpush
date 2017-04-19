# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/rpush/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-rpush"
  spec.version       = Capistrano::Rpush::VERSION
  spec.authors       = ["Mel Riffe"]
  spec.email         = ["mel@juicyparts.com"]
  spec.summary       = %q{Capistrano3 plugin with basic 'start', 'stop' commands for rpush.}
  spec.description   = %q{A set of Capistrano3 tasks to controll a deployed Rpush installation. The tasks include: restart, start, status, and stop.}
  spec.homepage      = "http://juicyparts.com/capistrano-rpush"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.post_install_message = "Thanks for installing!"
  spec.metadata = {
    "source_code"   => 'https://github.com/juicyparts/capistrano-rpush',
    "issue_tracker" => "https://github.com/juicyparts/capistrano-rpush/issues",
  }

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'capistrano', '~> 3.0', '< 4.0'
  spec.add_dependency 'rpush', '>= 2.7'
end

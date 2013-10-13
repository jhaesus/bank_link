# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bank_link/version"

Gem::Specification.new do |spec|
  spec.name          = "bank_link"
  spec.version       = BankLink::VERSION
  spec.authors       = ["Jhaesus"]
  spec.email         = ["jhaesus@gmail.com"]
  spec.description   = %q{Helper gem to simplify bank link usage}
  spec.summary       = %q{Gem for bank links}
  spec.homepage      = "http://github.com/jhaesus/bank_link"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2"
  if RUBY_VERSION >= "1.9.3"
    spec.add_development_dependency "rails"
  else
    spec.add_development_dependency "rails", "< 4"
  end
end


lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jamef/version"

Gem::Specification.new do |spec|
  spec.name          = "jamef-api"
  spec.version       = Jamef::VERSION
  spec.authors       = ["Agilso"]
  spec.email         = ["agilso.b@gmail.com"]

  spec.summary       = %q{Ruby wrapper for the Jamef API}
  spec.description   = %q{Ruby wrapper for the Jamef.com.br SOAP API.}
  spec.homepage      = "https://github.com/agilso/jamef-api"
  spec.license       = "MIT"

  # # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  
  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency 'savon', '~> 2.12.0'
end

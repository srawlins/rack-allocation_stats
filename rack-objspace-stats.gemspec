Gem::Specification.new do |spec|
  spec.name          = "rack-objspace-stats"
  spec.version       = "0.1.0"
  spec.authors       = ["Sam Rawlins"]
  spec.email         = ["sam.rawlins@gmail.com"]
  spec.license       = "Apache v2"
  spec.summary       = "Rack middleware for tracing object allocations in Ruby 2.1"
  spec.description   = "Rack middleware for tracing object allocations in Ruby 2.1"

  #spec.files         = `git ls-files`.split("\n")
  spec.files         = `find . -path "*.rb"`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_dependency "objspace-stats"
  spec.add_development_dependency "rspec"
end

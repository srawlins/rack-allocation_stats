# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

Gem::Specification.new do |spec|
  spec.name          = "rack-allocation_stats"
  spec.version       = "0.1.2"
  spec.authors       = ["Sam Rawlins"]
  spec.email         = ["sam.rawlins@gmail.com"]
  spec.homepage      = "https://github.com/srawlins/rack-allocation_stats"
  spec.license       = "Apache v2"
  spec.summary       = "Rack middleware for tracing object allocations in Ruby 2.1"
  spec.description   = "Rack middleware for tracing object allocations in Ruby 2.1; " +
                       "aggregate allocation information per Rack request; group, " +
                       "sort, and filter allocation information"

  spec.files         = Dir.glob("{lib,spec}/**/*") +
                         %w[CHANGELOG.markdown LICENSE README.markdown TODO.markdown]
  spec.require_paths = ["lib"]

  spec.add_dependency "allocation_stats", "0.1.3"
  spec.add_dependency "yajl-ruby"
  spec.add_development_dependency "rspec", "< 3"

  # ">= 2.1.0" seems logical, but rubygems thought that "2.1.0.dev.0" did not fit that bill.
  # "> 2.0.0" was my next guess, but apparently "2.0.0.247" _does_ fit that bill.
  spec.required_ruby_version = "> 2.0.99"
end

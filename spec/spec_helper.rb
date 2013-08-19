# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require_relative "../lib/rack/objectspace_stats"
require_relative "hello_world_app"
require_relative "yaml_app"
require_relative "yajl_app"

if RbConfig::CONFIG["MAJOR"].to_i < 2 || RbConfig::CONFIG["MINOR"].to_i < 1
  warn "Error: ObjectStats requires Ruby 2.1 or greater"
  exit 1
end

module Matchers
  class QueryString
    def initialize(expected_match)
      @expected_match = expected_match
    end

    def matches?(env)
      request = Rack::Request.new(env)
      query_string = request.GET
      #query_string.eql? @expected_match
      if query_string.eql? @expected_match
        true
      else
        env_description = "env, where Rack::Request.new(env).GET is #{query_string.inspect}"
        env.instance_eval <<-RUBY
          def description; #{env_description.inspect}; end
        RUBY
        false
      end
    end

    def description
      "query_string(#{@expected_match.inspect})"
    end

    def failure_message; end

    def negative_failure_message; end
  end

  def query_string(expected)
    QueryString.new(expected)
  end
end

RSpec.configure do |config|
  config.include Matchers
end

# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "bundler/setup"
require "rack"
require "allocation_stats"

require_relative "allocation_stats/action"
require_relative "allocation_stats/call_app_directly"
require_relative "allocation_stats/middleware"
require_relative "allocation_stats/tracer"

require_relative "allocation_stats/formatters/base"
require_relative "allocation_stats/formatters/html"
require_relative "allocation_stats/formatters/json"
require_relative "allocation_stats/formatters/text"

module Rack::AllocationStats
  def self.new(app, options = {})
    Middleware.new(app, options)
  end
end

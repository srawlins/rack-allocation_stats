# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "bundler/setup"
require "rack"
require "allocation_stats"

require_relative "allocation_stats/action"
require_relative "allocation_stats/call_app_directly"
require_relative "allocation_stats/middleware"
require_relative "allocation_stats/trace_allocations"

module Rack::AllocationStats
  def self.new(app, options = {})
    Middleware.new(app, options)
  end
end

# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "bundler/setup"
require "rack"
require "objectspace/stats"

require_relative "objectspace_stats/action"
require_relative "objectspace_stats/call_app_directly"
require_relative "objectspace_stats/middleware"
require_relative "objectspace_stats/trace_allocations"

module Rack::ObjectSpaceStats
  def self.new(app, options = {})
    Middleware.new(app, options)
  end
end

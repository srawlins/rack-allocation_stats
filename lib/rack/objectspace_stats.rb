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

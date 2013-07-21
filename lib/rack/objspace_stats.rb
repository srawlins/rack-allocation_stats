require "bundler/setup"
require "rack"
require "objspace/stats"

require_relative "objspace_stats/action"
require_relative "objspace_stats/call_app_directly"
require_relative "objspace_stats/middleware"
require_relative "objspace_stats/trace_allocations"

module Rack::ObjspaceStats
  def self.new(app, options = {})
    Middleware.new(app, options)
  end
end

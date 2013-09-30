# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

module Rack::AllocationStats
  class Middleware
    include Rack::Utils

    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      @env = env
      action = choose_action
      #action = TraceAllocations.new(@env, self)
      action.act
      action.response
    end

    def call_app(env)
      @app.call(env)
    end

    def choose_action
      request = Rack::Request.new(@env)
      if request.GET["ras"] && request.GET["ras"]["trace"]
        @content_type = request.GET["ras"]["output"] == "interactive" ? "text/html" : "text/plain"
        TraceAllocations.new(@env, self)
      else
        CallAppDirectly.new(@env, self)
      end
    end

    def allocation_stats_response(body)
      [200, headers(body), Array(body)]
    end

    def headers(body)
      {
        "Content-Type"   => @content_type,
        "Content-Length" => body.inject(0) { |len, part| len + bytesize(part) }.to_s
      }
    end
  end
end

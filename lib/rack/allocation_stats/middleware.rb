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
      action.act
      action.response
    end

    def call_app(env)
      @app.call(env)
    end

    def choose_action
      request = Rack::Request.new(@env)
      if request.GET["ras"] && request.GET["ras"].has_key?("help")
        @content_type = "text/plain"
        help_text
      elsif request.GET["ras"] && request.GET["ras"]["trace"]
        @content_type = content_type(request.GET["ras"]["output"])
        Tracer.new(@env, self)
      else
        CallAppDirectly.new(@env, self)
      end
    end

    def content_type(output_type)
      case output_type
      when "interactive" then "text/html"
      when "json"        then "application/json"
      else                    "text/plain"
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

    def help_text
      app = OpenStruct.new
      app.body = [File.read(File.join(__dir__, "help.txt"))]
      app.response = allocation_stats_response(app.body)
      app
    end
  end
end

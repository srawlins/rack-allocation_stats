# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require 'yajl'

module Rack::ObjectSpaceStats
  class TraceAllocations < Action
    include Rack::Utils

    def initialize(*args)
      super
      request = Rack::Request.new(@env)
      # Once we're here, GET["ros"] better exist
      @scope       = request.GET["ros"]["scope"]
      @times       = (request.GET["ros"]["times"] || 1).to_i
      @gc_report   = request.GET["ros"]["gc_report"]
      @interactive = request.GET["ros"]["interactive"]
      @new_env = delete_custom_params(@env)
    end

    def act
      @stats = ObjectSpace::Stats.new do
        @times.times do
          @middleware.call_app(@new_env)
        end
      end
    end

    def response
      if @scope
        if @scope == "."
          allocations = @stats.allocations.from_pwd#.
            #group_by(:sourcefile, :sourceline, :class_plus).
            #sorted_by_size.all
        else
          allocations = @stats.allocations.from(@scope)#.
            #group_by(:sourcefile, :sourceline, :class_plus).
            #sorted_by_size.all
        end
      else
        allocations = @stats.allocations#.group_by(:sourcefile, :sourceline, :class_plus).
          #sorted_by_size.all
      end

      if @interactive
        @middleware.objectspace_stats_response(build_html_body(allocations.all))
      else
        allocations = allocations.
          group_by(:sourcefile, :sourceline, :class_plus).
          sorted_by_size.all
        @middleware.objectspace_stats_response(build_text_body(allocations))
      end
    end

    def build_text_body(allocations)
      file_length = allocations.inject(0) {|l, allocation| l > allocation[0][0].length ? l : allocation[0][0].length }

      total_count = @stats.allocations.all.size
      sums = "Total: #{total_count} allocations; " +
        "#{@stats.allocations.bytes.all.inject { |sum, e| sum+e }} bytes\n\n"

      body = []

      #[sums] +

      if @gc_report
        gc_report = @stats.gc_profiler_report + "\n\n"
        body += [gc_report]
      end

      running_total = 0
      body + allocations.map do |gp, allocations|
        sourcefile = gp[0]
        sourceline = gp[1]
        klass      = gp[2]
        puts "A STRING: #{allocations.size.inspect} (#{allocations.size.class})" if allocations.size.class == String
        my_pct     = (allocations.size * 1.0 / total_count) * 100
        running_total += allocations.size
        puts "A STRING: #{running_total.inspect} (#{running_total.class})" if running_total.class == String
        running_pct = (running_total * 1.0 / total_count) * 100

        "%-#{file_length+4}s allocated %4d `%s` (%4.2f %4.2f)\n" % ["#{sourcefile}:#{sourceline}", allocations.size, klass, my_pct, running_pct]
        "%-#{file_length+4}s allocated %4d `%s`\n" % ["#{sourcefile}:#{sourceline}", allocations.size, klass]
      end
    end

    def build_html_body(allocations)
      index_html_erb     = ERB.new(File.read(File.join(__dir__, "interactive", "index.html.erb")))
      jquery_min_js      =         File.read(File.join(__dir__, "interactive", "jquery-2.0.3.min.js"))
      jquery_ui_min_js   =         File.read(File.join(__dir__, "interactive", "jquery-ui-1.10.3.custom.min.js"))
      underscore_min_js  =         File.read(File.join(__dir__, "interactive", "underscore-min.js"))
      allocations_js_erb = ERB.new(File.read(File.join(__dir__, "interactive", "allocations.js.erb")))
      allocations_js     = allocations_js_erb.result(binding)
      jquery_ui_min_css  =         File.read(File.join(__dir__, "interactive", "jquery-ui-1.10.3.custom.min.css"))
      style_css          =         File.read(File.join(__dir__, "interactive", "style.css"))

      allocating_gems = ["no gems allocated any objects"]

      html_body = index_html_erb.result(binding)
      return [html_body]
    end

    def delete_custom_params(env)
      new_env = env

      get_params = Rack::Request.new(new_env).GET
      get_params.delete("ros")

      new_env.delete("rack.request.query_string")
      new_env.delete("rack.request.query_hash")

      new_env["QUERY_STRING"] = build_query(get_params)
      new_env
    end
  end
end

# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

module Rack::AllocationStats
  class Action
    def initialize(env, middleware)
      @env = env
      @request = Rack::Request.new(env)
      @get_params = @request.GET.clone
      @middleware = middleware
      @stats = nil
    end
  end
end

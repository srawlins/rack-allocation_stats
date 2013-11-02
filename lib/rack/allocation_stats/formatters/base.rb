# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

module Rack::AllocationStats::Formatters
  class Base
    def initialize(tracer, allocations)
      @tracer = tracer
      @allocations = allocations
    end
  end
end

module Rack::AllocationStats::Formatters
  class Base
    def initialize(trace_allocations, allocations)
      @trace_allocations = trace_allocations
      @allocations = allocations
    end
  end
end

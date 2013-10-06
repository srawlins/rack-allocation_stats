module Rack::AllocationStats::Formatters
  class Base
    def initialize(tracer, allocations)
      @tracer = tracer
      @allocations = allocations
    end
  end
end

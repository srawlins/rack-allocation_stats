class Rack::AllocationStats::Formatters::JSON < Rack::AllocationStats::Formatters::Base
  def format
    allocations = @allocations.to_a.map do |group_key, allocations|
      { group_key: group_key, allocations: allocations }
    end

    return [Yajl::Encoder.encode(allocations)]
  end
end

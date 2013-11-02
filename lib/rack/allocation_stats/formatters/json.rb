# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

class Rack::AllocationStats::Formatters::JSON < Rack::AllocationStats::Formatters::Base
  def format
    allocations = @allocations.to_a.map do |group_key, allocations|
      { group_key: group_key, allocations: allocations }
    end

    return [Yajl::Encoder.encode(allocations)]
  end
end

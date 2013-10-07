FactoryGirl.define do
  factory :allocation, class: AllocationStats::Allocation do

    ignore do
      object "A String"
      sourcefile "foo/bar.rb"
      sourceline 7
    end

    initialize_with { new(object) }

    after(:build) do |allocation, evaluator|
      allocation.instance_variable_set(:@sourcefile, evaluator.sourcefile)
      allocation.instance_variable_set(:@sourceline, evaluator.sourceline)
    end
  end

  # This might be overly complicated for now... but it was terribly fun to learn
  # FactoryGirl's API, and I'll leave it for future use...
  factory :stats, class: AllocationStats do
    ignore do
      size 5
      files ["foo/bar.rb", "baz/quux.rb"]
      sourceline 7
    end

    after(:build) do |stats, evaluator|
      allocations = []
      size = evaluator.size
      files_count = evaluator.files.size

      # 3 from 1st file
      if size > 0
        file = evaluator.files[0]
        count = [size, 3].min
        count.times { allocations << FactoryGirl.build(:allocation, sourcefile: file, sourceline: evaluator.sourceline) }
        size -= count
      end

      # more from 2nd file
      if size > 0
        file = evaluator.files[1 % files_count]
        size.times { allocations << FactoryGirl.build(:allocation, sourcefile: file, sourceline: evaluator.sourceline) }
        size -= count
      end

      stats.instance_variable_set(:@new_allocations, allocations)
    end
  end
end

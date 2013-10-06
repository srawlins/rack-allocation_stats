class Rack::AllocationStats::Formatters::Text < Rack::AllocationStats::Formatters::Base
  def format
    file_length = @allocations.inject(0) { |length, allocation| [allocation[0][0].length , length].max }

    total_count = @tracer.stats.allocations.all.size
    bytes = @tracer.stats.allocations.bytes.all.inject { |sum, e| sum + e }
    sums = "Total: #{total_count} allocations; #{bytes} bytes\n\n"

    body = []

    if @tracer.gc_report
      gc_report = @tracer.stats.gc_profiler_report + "\n\n"
      body += [gc_report]
    end

    running_total = 0
    body + @allocations.map do |key, group|
      sourcefile = key[0]
      sourceline = key[1]
      klass      = key[2]
      my_pct     = (group.size * 1.0 / total_count) * 100
      running_total += group.size
      running_pct = (running_total * 1.0 / total_count) * 100

      # TODO add a parameter to show/hide pct
      #"%-#{file_length+4}s allocated %4d `%s` (%4.2f %4.2f)\n" % ["#{sourcefile}:#{sourceline}", group.size, klass, my_pct, running_pct]
      "%-#{file_length+4}s allocated %4d `%s`\n" % ["#{sourcefile}:#{sourceline}", group.size, klass]
    end
  end
end

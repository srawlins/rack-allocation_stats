rack-allocation_stats is a Rack Middleware, similar in design to
[rack-perftools_profiler](https://github.com/bhb/rack-perftools_profiler), that
will show information about object allocations that occurr during an HTTP
request.

API
===

In order to trigger rack-allocation_stats, a parameter must be appended to the
request URL: `ros[trace]=true` ('ros' for rack-allocation_stats). Alongside
that, the following parameters are also available:

* `ros[scope]`
* `ros[times]`
* `ros[interactive]`

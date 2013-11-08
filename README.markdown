Rack AllocationStats is a Rack Middleware, similar in design to
[rack-perftools_profiler](https://github.com/bhb/rack-perftools_profiler), that
will show information about object allocations that occurr during an HTTP
request. The heart of Rack AllocationStats is the
[AllocationStats](https://github.com/srawlins/allocation_stats) gem. Install
Rack AllocationStats with Ruby 2.1 (newer than preview1) and:

* Bundler: add `gem 'rack-allocation_stats'` to your Gemfile, or
* RubyGems: run `gem install rack-allocation_stats`

API
===

In order to trigger Rack AllocationStats, a parameter must be appended to the
request URL: `ras[trace]=true` ('ras' for Rack AllocationStats). This will
trace the object allocations that occur inside your Rack app during your
request. Instead of the normal response that your app generates, Rack
AllocationStats will respond with a tabular listing of allocation statistics.
There are additional paramters that you can attach to the request URL to change
the response:

Limit the file system scope
---------------------------

If you only wish to see allocations originating in a certain directory, you can
use the `ras[scope]` parameter. For example:

* To limit the list of allocations to those with a `sourcefile` that includes
  `yajl`, append to the location:
  ```
  ?ras[trace]=true&ras[scope]=yajl
  ```

* To limit the list of allocations to those in the present working directory.
  `.` is a special value for `ras[scope]` that is expanded to the full path of
  the present working directory, append to the location:
  ```
  ?ras[trace]=true&ras[scope]=.
  ```

Alias paths
-----------

In order to reduce the with of the `sourcefile`, you can add
`&ras[alias_paths]=true`, which will shorten paths in the following directories:

* your present working directory (replaced with `<PWD>`)
* Ruby's `lib` directory (replaced with `<RUBYLIBDIR>`)
* the Gem directory, where installed gems live (replaced with `<GEMDIR>`)

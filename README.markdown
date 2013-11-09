Rack AllocationStats is a Rack Middleware, similar in design to
[rack-perftools_profiler](https://github.com/bhb/rack-perftools_profiler), that
will show information about object allocations that occurr during an HTTP
request. The heart of Rack AllocationStats is the
[AllocationStats](https://github.com/srawlins/allocation_stats) gem. Install
Rack AllocationStats with Ruby 2.1 (newer than preview1) and:

* Bundler: add `gem 'rack-allocation_stats'` to your Gemfile, or
* RubyGems: run `gem install rack-allocation_stats`

Rack AllocationStats must also be included in your Rack application's middleware:

Rails:

```ruby
# in your config/application.rb
config.middleware.use ::Rack::AllocationStats
```

Other Rack apps:

```ruby
# in your rackup file
use Rack::AllocationStats
```

Summary
=======

In order to trigger Rack AllocationStats, a parameter must be appended to the
request URL: `ras[trace]=true` ('ras' for Rack AllocationStats). This will
trace the object allocations that occur inside your Rack app during your
request.

For example, if you have a Rack app that responds to the following request:

```bash
http://my.rack.app:9292/path?foo=bar
```

then you can just add `&ras[trace]=true` to activate Rack AllocationStats:

```bash
http://my.rack.app:9292/path?foo=bar&ras[trace]=true
```

Instead of the normal response that your app generates, Rack
AllocationStats will respond with a tabular listing of allocation statistics.

![Demonstration](basic-screen.gif)

There are additional paramters that you can attach to the request URL to change
the response:

Help text
=========

To see some help text on what options are available, use `ras[trace]=true`, and
also add `ras[help]`. Rack AllocationStats will respond with man page-style
help text.

Limit the file system scope
===========================

If you only wish to see allocations that originate from a certain directory, you can
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
===========

In order to reduce the with of the `sourcefile`, you can add
`ras[alias_paths]=true`, which will shorten paths in the following directories:

* your present working directory (to be replaced with `<PWD>`)
* Ruby's `lib` directory (to be replaced with `<RUBYLIBDIR>`)
* the Gem directory, where installed gems live (eg: sqlite3-1.3.8 to be
  replaced with `<GEM:sqlite3-1.3.8>`)

Change the output
=================

There are several values that you can pass with `ras[output]` parameter:

* `columnar` is the default response output, displaying allocation groups in
  text columns.
* `json` will respond with a JSON string representing all of the groups of
  allocations (by default grouped by sourcefile, sourceline, and object class).
* `interactive` will respond with a JavaScript application that allows you to
  interactively tweak how you wish to group, arrange, and filter the traced
  allocations.

Request multiple times
======================

If your Rack application appears to have some variability, you can use
`ras[times]=N` to pass the request onto your Rack application `N` times. The
response that Rack AllocationStats generates will contain all of the requests
that occurred over the `N` requests.

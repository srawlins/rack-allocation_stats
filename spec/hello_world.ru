# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "./spec/hello_world_app"
require "./lib/rack/allocation_stats"

use Rack::AllocationStats
run HelloWorldApp.new

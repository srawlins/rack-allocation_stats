# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "./spec/sinatra_templates_app"
require "./lib/rack/objectspace_stats"

use Rack::ObjectSpaceStats
run SinatraTemplatesApp.new

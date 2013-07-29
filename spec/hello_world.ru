require "./spec/hello_world_app"
require "./lib/rack/objectspace_stats"

use Rack::ObjectSpaceStats
run HelloWorldApp.new

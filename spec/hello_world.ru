require "./spec/hello_world_app"
require "./lib/rack/objspace_stats"

use Rack::ObjspaceStats
run HelloWorldApp.new

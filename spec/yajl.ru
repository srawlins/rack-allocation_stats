require "./spec/yajl_app"
require "./lib/rack/objectspace_stats"

use Rack::ObjectSpaceStats
run YajlApp.new

require "./spec/yajl_app"
require "./lib/rack/objspace_stats"

use Rack::ObjspaceStats
run YajlApp.new

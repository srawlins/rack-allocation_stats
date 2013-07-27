require "./spec/yaml_app"
require "./lib/rack/objspace_stats"

use Rack::ObjspaceStats
run YamlApp.new

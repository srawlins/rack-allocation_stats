require "./spec/yaml_app"
require "./lib/rack/objectspace_stats"

use Rack::ObjectSpaceStats
run YamlApp.new

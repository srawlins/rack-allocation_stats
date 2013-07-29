require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :fetch_minimal_jquery_ui do
  # We just want to check "Spinner", which adds "Button", "Widget", and "Core"
  `wget -O jquery-ui.zip --post-data="version=1.10.3&core=on&widget=on&button=on&spinner=on&theme=none&theme-folder-name=no-theme&scope=" http://download.jqueryui.com/download && unzip -d jquery-ui -j -n -q jquery-ui.zip && mv jquery-ui/jquery-ui-1.10.3.custom.min.* lib/rack/objspace_stats/interactive && rm -r jquery-ui jquery-ui.zip`
end

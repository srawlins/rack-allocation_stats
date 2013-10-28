# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require 'rspec/core/rake_task'
require 'sass'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :sass do
  Sass.compile_file("lib/rack/allocation_stats/interactive/style.scss",
                    "lib/rack/allocation_stats/interactive/style.css",
                    cache: false, syntax: :scss)
end

task :fetch_minimal_jquery_ui do
  # We just want to check "Spinner", which adds "Button", "Widget", and "Core"
  `wget -O jquery-ui.zip --post-data="version=1.10.3&core=on&widget=on&button=on&spinner=on&theme=none&theme-folder-name=no-theme&scope=" http://download.jqueryui.com/download && unzip -d jquery-ui -j -n -q jquery-ui.zip && mv jquery-ui/jquery-ui-1.10.3.custom.min.* lib/rack/allocation_stats/interactive && rm -r jquery-ui jquery-ui.zip`
end

task :fetch_jasmine_files do
  jasmine_css_files = [
    "docco.css",
    "jasmine_docco-1.3.1.css"
  ]

  jasmine_js_files = [
    "jasmine-html.js",
    "jasmine.css",
    "jasmine.js"
  ]

  jasmine_css_files.each do |jf|
    command = "wget -q -O spec/javascripts/css/#{jf} https://github.com/pivotal/jasmine/raw/gh-pages/css/#{jf}"
    puts command
    `#{command}`
  end

  jasmine_js_files.each do |jf|
    command = "wget -q -O spec/javascripts/js/#{jf} https://github.com/pivotal/jasmine/raw/gh-pages/lib/jasmine-1.3.1/#{jf}"
    puts command
    `#{command}`
  end
end

task :pages do
  FileUtils.rm_f "spec/javascripts/interactive_spec.html"

  js_specs = File.join(__dir__, "spec", "javascripts", "interactive_spec.js")
  layout = File.join(__dir__, "spec", "javascripts", "interactive_spec.html.mustache")
  `bundle exec rocco -l js #{js_specs} -t #{layout} -o .`
end

class Rack::AllocationStats::Formatters::HTML < Rack::AllocationStats::Formatters::Base
  def format
    interactive_dir = File.join(__dir__, "..", "interactive")

    index_html_erb     = ERB.new(File.read(File.join(interactive_dir, "index.html.erb")))
    jquery_min_js      =         File.read(File.join(interactive_dir, "jquery-2.0.3.min.js"))
    jquery_ui_min_js   =         File.read(File.join(interactive_dir, "jquery-ui-1.10.3.custom.min.js"))
    underscore_min_js  =         File.read(File.join(interactive_dir, "underscore-min.js"))
    allocations_js_erb = ERB.new(File.read(File.join(interactive_dir, "allocations.js.erb")))
    allocations_js     = allocations_js_erb.result(binding)
    jquery_ui_min_css  =         File.read(File.join(interactive_dir, "jquery-ui-1.10.3.custom.min.css"))
    style_css          =         File.read(File.join(interactive_dir, "style.css"))

    allocating_gems = ["no gems allocated any objects"]

    html_body = index_html_erb.result(binding)
    return [html_body]
  end
end

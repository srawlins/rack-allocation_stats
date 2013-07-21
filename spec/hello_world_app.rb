require "rack"
require "yaml"

class HelloWorldApp
  FULL_PATH = __FILE__

  attr_accessor :allocating_lines

  def initialize
    @allocating_lines = []
  end

  def call(env)
    a = "Ahhhhhhhhhhhhhhhhhhhhh"; @allocating_lines << __LINE__
    #y = YAML.dump(["one string", "two string"]) # lots OF objects not from here
    @allocating_lines << __LINE__; [200, {"Content-Type" => "text/html"}, ["Hello Rack!"]]
  end
end

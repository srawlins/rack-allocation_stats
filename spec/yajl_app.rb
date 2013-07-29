require "rack"
require "yajl"

class YajlApp
  FULL_PATH = __FILE__

  attr_accessor :allocating_lines

  def initialize
    @allocating_lines = []
  end

  def call(env)
    y = Yajl.dump(["one string", "two string", {"uno" => 1, "two" => 2}, "ho "*3]); @allocating_lines << __LINE__ # lots of objects not from here
    @allocating_lines << __LINE__; [200, {"Content-Type" => "text/html"}, ["Hello Rack!"]]
  end
end

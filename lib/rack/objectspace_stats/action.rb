module Rack::ObjectSpaceStats
  class Action
    def initialize(env, middleware)
      @env = env
      @request = Rack::Request.new(env)
      @get_params = @request.GET.clone
      @middleware = middleware
      @stats = nil
    end
  end
end

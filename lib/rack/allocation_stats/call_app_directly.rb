# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

module Rack::ObjectSpaceStats
  class CallAppDirectly < Action
    def act
      @result = @middleware.call_app(@env)
    end

    def response
      @result
    end
  end
end

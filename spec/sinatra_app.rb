# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "sinatra"

class HelloSinatraApp < Sinatra::Base
  get "/hello" do
    "Hello World!"
  end
end

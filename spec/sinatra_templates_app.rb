# Copyright 2013 Google Inc. All Rights Reserved.
# Licensed under the Apache License, Version 2.0, found in the LICENSE file.

require "sinatra"
require "haml"
require "liquid"
require "redcarpet"
require "slim"

class SinatraTemplatesApp < Sinatra::Base
  HELLOS = ["Hello", "Hola", "Bonjour", "Gutentag",
            "こんにちは", "привет"]

  enable :inline_templates

  get "/erb" do
    erb :erb
  end

  get "/haml" do
    haml :haml
  end

  get "/liquid" do
    liquid :liquid, locals: { hellos: HELLOS }
  end

  get "/slim" do
    slim :slim
  end

  get "/markdown" do
    markdown(:markdown)
  end
end

__END__

@@ erb
<html>
  <body>
    <ul id="hi">
      <% HELLOS.each do |hello| %>
        <li class="greeting"><%= hello %> World!</li>
      <% end %>
    </ul>
  </body>
</html>

@@ haml
%html
  %body
    %ul#hi
      - HELLOS.each do |hello|
        %li.greeting
          =hello
          World!

@@ liquid
<html>
  <body>
    <ul>
      {% for hello in hellos %}
        <li class="greeting">{{ hello }} World!</li>
      {% endfor %}
    </ul>
  </body>
</html>

@@ markdown
* Hello World!
* Hola World!
* Bonjour World!
* Gutentag World!
* こんにちは World!
* привет World!

@@ slim
html
  body
    ul id="hi"
      - HELLOS.each do |hello|
        li.greeting
          = hello
          |  World!

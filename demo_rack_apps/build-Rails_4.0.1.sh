#!/bin/bash
app=`rails _4.0.1_ -v |tr ' ' _`

rm -rf $app
rails _4.0.1_ new $app
cd $app

echo "gem 'allocation_stats', path: '../../../allocation_stats'" >> Gemfile
echo "gem 'rack-allocation_stats', path: '../../'" >> Gemfile
bundle

bundle exec rails generate scaffold Project name:string priority:integer description:text
bundle exec rails generate scaffold Task name:string description:text project_id:integer

cat app/models/task.rb |head --lines=-1 > task.rb
echo "  belongs_to :project" >> task.rb
echo "end" >> task.rb
mv task.rb app/models/

cat app/models/project.rb |head --lines=-1 > project.rb
echo "  has_many :tasks" >> project.rb
echo "end" >> project.rb
mv project.rb app/models/

cat config/application.rb |head --lines=-2 > application.rb
echo "    config.middleware.use ::Rack::AllocationStats" >> application.rb
echo "  end" >> application.rb
echo "end" >> application.rb
mv application.rb config/

RAILS_ENV=production bundle exec rake db:create db:migrate assets:precompile

cat > db/seeds.rb <<EOF
10.times do |i|
  project = Project.create(
    name: "Project #{i}",
    priority: i**2,
    description: "Project #{i} has a long description." * 8
  )

  4.times do |j|
    Task.create(
      name: "Task #{j+1}",
      project_id: project.id,
      description: "Task #{j+1} in Project #{i} has a long description" * 5
    )
  end
end
EOF

RAILS_ENV=production bundle exec rake db:seed

cat > app/views/projects/index.html.erb <<EOF
<h1>Projects</h1>

<p>
  This page should render a listing of 10 projects, each of which has 4 tasks.
  Each project and each task has 1x 'string' column, and 1x 'text' column.
  Theoretically, this amounts to 2 * (10 + 10*4) = 100x string-or-text retreived
  fields.
</p>

<% @projects.each do |project| %>
<h2><%= link_to project.name, project %></h2>
  <p>Priority: <%= project.priority %></p>
  <p><%= project.description %></p>
  <ul>
    <% project.tasks.each do |task| %>
      <li><em><%= task.name %></em>: <%= task.description %></li>
    <% end %>
  </ul>
<% end %>

<%= link_to 'New Project', new_project_path %>
EOF

require_relative "../spec_helper"

describe Rack::ObjectSpaceStats do
  before do
    @app = HelloWorldApp.new
    @vanilla_request_env = Rack::MockRequest.env_for("/")
    @traced_request_env  = Rack::MockRequest.env_for("/", :params => "ros[trace]=true")
  end

  it "should return something when called with a tracing request" do
    status, headers, _ = Rack::ObjectSpaceStats.new(@app).call(@traced_request_env)

    expect(headers["Content-Type"]).to eq "text/plain"
    expect(status).to be 200
  end

  it "should not interfere when not a trace request" do
    _, _, body = Rack::ObjectSpaceStats.new(@app).call(@vanilla_request_env)

    expect(body).to eq ["Hello Rack!"]
  end

  it "should delete ros[] params before hitting next app" do
    objectspace_stats = Rack::ObjectSpaceStats.new(@app)

    @app.should_receive(:call).with(query_string({}))

    status, headers, _ = objectspace_stats.call(@traced_request_env)
  end

  it "should return correct body when called with a tracing request" do
    _, _, body = Rack::ObjectSpaceStats.new(@app).call(@traced_request_env)

    expected_body = [
      "#{HelloWorldApp::FULL_PATH}:#{@app.allocating_lines[1]}  allocated    4 `String`\n",
      "#{HelloWorldApp::FULL_PATH}:#{@app.allocating_lines[1]}  allocated    1 `Array<String>`\n",
      "#{HelloWorldApp::FULL_PATH}:#{@app.allocating_lines[1]}  allocated    1 `Array<Fixnum,Hash,Array>`\n",
      "#{HelloWorldApp::FULL_PATH}:#{@app.allocating_lines[1]}  allocated    1 `Hash`\n",
      "#{HelloWorldApp::FULL_PATH}:#{@app.allocating_lines[0]}  allocated    1 `String`\n"
    ]

    expect(body).to include(expected_body[0])
    expect(body).to include(expected_body[1])
    expect(body).to include(expected_body[2])
    expect(body).to include(expected_body[3])
  end

  it "should return correct body when called on just local files" do
    yaml_app = YamlApp.new
    local_request_env  = Rack::MockRequest.env_for("/", :params => "ros[trace]=true&ros[scope]=.")
    _, _, body = Rack::ObjectSpaceStats.new(yaml_app).call(local_request_env)

    # should be:
    # yaml_app.rb:15  allocated    4 `String`
    # yaml_app.rb:14  allocated    2 `String`
    # yaml_app.rb:14  allocated    1 `Array<>`
    # yaml_app.rb:14  allocated    1 `Array<String>`
    # yaml_app.rb:15  allocated    1 `Array<Fixnum,Hash,Array>`
    # yaml_app.rb:15  allocated    1 `Array<String>`
    # yaml_app.rb:15  allocated    1 `Hash`

    expect(body.size).to eq 7
  end

  it "should return correct body when called on a specific directory" do
    yaml_app = YamlApp.new
    psych_request_env  = Rack::MockRequest.env_for("/", :params => "ros[trace]=true&ros[scope]=psych")
    _, _, body = Rack::ObjectSpaceStats.new(yaml_app).call(psych_request_env)

    expect(body.size).to eq 44
  end

  it "should return HTML5 in response to an interactive request" do
    interactive_request_env  = Rack::MockRequest.env_for("/", :params => "ros[trace]=true&ros[interactive]=true")
    _, _, body = Rack::ObjectSpaceStats.new(@app).call(interactive_request_env)

    expect(body[0]).to match /^<!DOCTYPE html>/
  end
end

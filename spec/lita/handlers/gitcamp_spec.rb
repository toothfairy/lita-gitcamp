require "spec_helper"
require "hashie"

describe Lita::Handlers::Gitcamp, lita_handler: true do
  before do
    stub_request(:get, "https://api.github.com/repos/octokitty/testing/issues/1").
      with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Octokit Ruby Gem 2.4.0'}).
      to_return(
        status: 200,
        body: lambda do |request|
          id = request.uri.to_s.match /issues\/(\d+)/
          Hashie::Mash.new(JSON.parse(File.read("./spec/api_data/issue_payload.json")))
        end,
        headers:{})

    stub_request(:put, "https://basecamp.com/api/v1/projects/1/todos/2.json").
         with(:body => "{\"completed\":true}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.8.8'}).
         to_return(:status => 200, :body => "", :headers => {})
  end

  it "routes properly" do
    routes_http(:post, "/gitcamp").to(:receive)
  end

  describe "receive github payload" do 
    let(:response) do 
      response = double("Rack::Response.new")
      response.stub(:reply) do |args|
        replies << args
      end
      response
    end
    let(:robot) { double("Lita::Robot") }

    subject {Lita::Handlers::Gitcamp.new(robot)}

    context "with valid data" do 
      let(:request) do
        request = double("Rack::Request")
        request.stub(:params) {{ "payload" => File.read('./spec/api_data/push_payload_full.json') }}
        request
      end

      it "assepts some github stuff" do
        expect {
          subject.receive(request, response)
        }.to_not raise_error
      end

      it "answers with proper todos count" do
        subject.receive(request, response)
        expect(replies.last).to eq("Basecamp tasks closed: 1")
      end
    end

    context "with invalid data" do
      let(:request) do
        request = double("Rack::Request")
        request.stub(:params) {{}}
        request
      end

      it "ignores invalid payload" do
        subject.receive(request, response)
        expect(true).to be_true
      end
    end
  end

  describe "parse closed issues" do
    let(:payload) {JSON.parse(File.read('./spec/api_data/push_payload.json'))}

    it "returns closed issue numbers" do
      subject.parse_payload(payload).should eq([["1", "2"], "octokitty", "testing"])
    end

    it "doesnt fail on emtpy payload" do
      subject.parse_payload({}).should eq(nil)
    end
  end

  describe "todos from issues" do
    let(:issue_body) {"I'm having a problem with humanity. https://basecamp.com/123123/projects/1-project/todos/2"}

    it "get todos numbers" do
      subject.get_todos_numbers(["1"], "octokitty", "testing").should eq([{project_id: "1", task_id: "2"} ])
    end

    it "parse todos from issue body" do
      subject.parse_issue_body(issue_body).should eq({project_id: "1", task_id: "2"})
    end
  end

  describe "basecamp todos" do
    let(:tasks) {[{project_id: "1", task_id: "2"}]}

    it "close todos" do
      expect{subject.finish_basecamp_tasks(tasks)}.not_to raise_error
    end
  end
end
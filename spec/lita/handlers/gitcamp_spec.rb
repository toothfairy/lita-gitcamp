require "spec_helper"

describe Lita::Handlers::Gitcamp, lita_handler: true do
  it "routes properly" do
    routes_http(:post, "/gitcamp").to(:receive)
  end

  describe "receive github payload" do 
    let(:response) { Rack::Response.new }
    let(:robot) { double("Lita::Robot") }

    subject {Lita::Handlers::Gitcamp.new(robot)}

    context "with valid data" do 
      let(:request) do
        request = double("Rack::Request")
        request.stub(:params) {{ payload: File.read('./spec/api_data/push_payload.json') }}
        request
      end

      it "assepts some github stuff" do
        subject.receive(request, response)
        expect(true).to be_true
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
      subject.parse_payload(payload).should eql([["1", "2"], "octokitty", "testing"])
    end

    it "doesnt fail on emtpy payload" do
      subject.parse_payload({}).should eql(nil)
    end
  end

  describe "todos from issues" do
    let(:issue_body) {"I'm having a problem with humanity. https://basecamp.com/123123/projects/123123-project/todos/666"}

    before do
      stub_request(:get, "https://api.github.com/repos/octocat/Hello-World/issues/1347").
         with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Octokit Ruby Gem 2.4.0'}).
         to_return(
          status: 200,
          body: lambda do |request|
            id = request.uri.to_s.match /issues\/(\d+)/
            Hashie::Mash.new(JSON.parse(File.read("./spec/api_data/issue_payload.json")))
          end,
          headers:{})
    end

    it "get todos numbers" do
      subject.get_todos_numbers(["1347"], "octocat", "Hello-World").should eql(["666"])
    end

    it "parse todos from issue body" do
      subject.parse_issue_body(issue_body).should eql("666")
    end
  end
end
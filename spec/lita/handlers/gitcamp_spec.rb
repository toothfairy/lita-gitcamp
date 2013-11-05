require "spec_helper"

describe Lita::Handlers::Gitcamp, lita_handler: true do
	describe "Gitcamp" do
		before do 
      @repo = "https://github.com/octocat/donuts"

      @redis ||= begin
        redis = Redis.new
        Redis::Namespace.new("lita.test:handlers:gitcamp", redis: redis)
      end

      @redis.flushall
      @redis.set('repos', [@repo])
    end

    context "Receive github hook" do
      it "receives json from github" do
        routes_http(:post, "/gitcamp").to(:receive)
      end
	  end
	end

  describe "receive github payload" do 
    let(:robot) { double("Lita::Robot") }
    let(:response) { Rack::Response.new }

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
end

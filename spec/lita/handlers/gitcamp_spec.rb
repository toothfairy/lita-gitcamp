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
      subject.parse_payload(payload).should eql(["1", "2"])
    end

    it "doesnt fail on emtpy payload" do
      subject.parse_payload({}).should eql(nil)
    end
  end
end

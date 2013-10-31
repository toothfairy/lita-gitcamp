require "spec_helper"
require "redis-namespace"

REDIS_NAMESPACE = "lita.test:handlers:receptionist"

describe Lita::Handlers::Receptionist, lita_handler: true do
  describe "Receptionist" do
    before do 
      @repo = "https://github.com/octocat/donuts"

      @redis ||= begin
        redis = Redis.new
        Redis::Namespace.new(REDIS_NAMESPACE, redis: redis)
      end

      @redis.flushall
    end
    
    context "Add repo"
      it "registers github repository to handle commits" do
        send_command("add gitcamp repo #{@repo}")
        repos = @redis.get('repos') || []
        
        repos.should include(@repo)
      end

      it "responds positively" do
        send_command("add gitcamp repo #{@repo}")
        expect(replies.last).to eq(
          "Repo registered"
        )
      end
    end
  end
end
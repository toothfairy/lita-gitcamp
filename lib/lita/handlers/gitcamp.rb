require "lita"

module Lita
  module Handlers
    class Gitcamp < Handler
    	http.post "/gitcamp", :receive

    	def self.default_config(config)
    		config.rooms = :all
    		config.token = nil
    	end

    	def receive(request, responce)
        if request.params.has_key? "payload"
          payload = JSON.parse(request.params[:payload])
          colsed_issues = parse_payload payload
        end
    	end

      def parse_payload(payload)
        if payload.has_key? "commits"
          regex = /(?:close|fix|resolve)\w*?\s\#(\d+)/i

          messages = payload["commits"].collect {|c| c["message"]}.join(",")
          messages.scan(regex).flatten
        end
      end
    end

    Lita.register_handler(Gitcamp)
  end
end

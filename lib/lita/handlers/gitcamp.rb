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
        if request.params.has_key? :payload
          push = JSON.parse(request.params[:payload])
        end # possibly write to log
    	end
    end

    Lita.register_handler(Gitcamp)
  end
end

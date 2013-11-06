require "lita"

module Lita
  module Handlers
    class Receptionist < Handler
      route /^add\sgitcamp\srepo\s(?:http|https)\:\/\/github.com\/(?<owner>[a-zA-Z\-]+)\/(?<name>[a-zA-Z\-]+)/, :add_repo
      route /^remove\sgitcamp\srepo\s(?:http|https)\:\/\/github.com\/(?<owner>[a-zA-Z\-]+)\/(?<name>[a-zA-Z\-]+)/, :remove_repo

      def add_repo(response)
        repo_name = "https://github.com/#{response.matches[0][0]}/#{response.matches[0][1]}"
        repos = redis.get('repos') || []

        unless repos.include? repo_name
          repos << repo_name
          redis.set('repos', repos)
          response.reply "Repo added"
        end
      end
      
      def remove_repo(response)
        repo_name = "https://github.com/#{response.matches[0][0]}/#{response.matches[0][1]}"
        repos = redis.get('repos') || []

        if repos.include? repo_name
          repos = repos.delete repo_name
          redis.set('repos', repos)
          response.reply "Repo removed"
        end
      end
    end

    Lita.register_handler(Gitcamp)
  end
end

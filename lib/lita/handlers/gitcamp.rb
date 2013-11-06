require "lita"
require "octokit"
require "bcx"

module Lita
  module Handlers
    class Gitcamp < Handler
      http.post "/gitcamp", :receive

      def self.default_config(config)
        config.rooms = :all
        config.github_token = nil
        config.basecamp_login = nil
        config.basecamp_password = nil
        config.basecamp_account = nil
      end

      def receive(request, responce)
        if request.params.has_key? "payload"
          payload = JSON.parse(request.params[:payload])
          colsed_issues, owner, repo = parse_payload payload
          tasks = get_todos_numbers(colsed_issues, owner, repo)
          finish_basecamp_tasks
        end
      end

      def parse_payload(payload)
        issues = []
        if payload.has_key? "commits"
          regex = /(?:close|fix|resolve)\w*?\s\#(\d+)/im

          messages = payload["commits"].collect {|c| c["message"]}.join(",")
          issues = messages.scan(regex).flatten

          [issues, payload["repository"]["owner"]["name"], payload["repository"]["name"]]
        end
      end

      def get_todos_numbers(issues, owner, repo)
        todos = []
        client = Octokit::Client.new access_token: Lita.config.handlers.gitcamp.github_token
        issues.each do |i|
          # GET /repos/:owner/:repo/issues/:number
          issue = client.issue("#{owner}/#{repo}", i)
          todo_id = parse_issue_body(issue.body)
          todos << todo_id unless todo_id.nil?
        end

        todos
      end

      def parse_issue_body(body)
        regex = /basecamp.com\/\d+\/projects\/(\d+)(?:-\w*?)\/todos\/(\d+)/mi
        captures = body.match(regex).captures
        {project_id: captures[0], task_id: captures[1]}
      end

      def finish_basecamp_tasks(tasks)
        client = basecamp_client

        tasks.each do |t|
          client.projects(t[:project_id]).todos(t[:task_id]).update!(completed: true)
        end
      end

      def basecamp_client
        Bcx.configure do |config|
          config.account = Lita.config.handlers.gitcamp.basecamp_account
        end
        
        Bcx::Client::HTTP.new(
          login: Lita.config.handlers.gitcamp.basecamp_login,
          password: Lita.config.handlers.gitcamp.basecamp_password
        )
      end
    end

    Lita.register_handler(Gitcamp)
  end
end
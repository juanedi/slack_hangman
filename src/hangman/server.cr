require "http/server"
require "slack"

class Hangman::Server
  delegate listen, close, to: @server

  def initialize(host, port)
    @server = HTTP::Server.new(host, port) do |context|
      begin
        handle_request context
      rescue ex
        ex.backtrace.each do |bt|
          puts bt
        end
        context.response.content_type = "text/plain"
        context.response.print "Error handling request: #{ex}"
      end
    end
  end

  def handle_request(context)
    request = context.request
    Hangman.logger.info "Request: #{request.path} - #{request.body}"

    case request.path
    when %r(/slack/oauth/?)
      handle_oauth context
    when %r(/slack/command/?)
      handle_command context
    when %r(/slack/interactions/?)
      handle_button_action context
    else
      context.response.status_code = 400
    end

    context
  end

  def handle_oauth(context)
    authorization_code = context.request.query_params["code"]

    body = HTTP::Params.build do |form|
      form.add "client_id", ENV["SLACK_CLIENT_ID"]
      form.add "client_secret", ENV["SLACK_CLIENT_SECRET"]
      form.add "redirect_uri", ENV["SLACK_REDIRECT_URI"]
      form.add "grant_type", "authorization_code"
      form.add "code", authorization_code
    end

    token_uri = URI.new("https", "slack.com", 443, "/api/oauth.access").to_s
    slack_response = HTTP::Client.post_form(token_uri, body)

    context.response.status_code = 200
    context.response.content_type = "application/json"
    context.response.print(slack_response.body)
  end

  def handle_command(context)
    request = context.request
    slash_command = Slack::SlashCommand.from_request(request)
    unless slash_command.token == ENV["SLACK_VERIFICATION_TOKEN"]
      context.response.status_code = 401
      return context
    end

    Hangman::Slack::Commands.handle(slash_command)
    context.response.status_code = 200
    context.response.print("Starting game...")
  end

  def handle_button_action(context)
    context.response.status_code = 200
    context.response.content_type = "text/plain"
    context.response.print("Not implemented yet :)")
  end
end

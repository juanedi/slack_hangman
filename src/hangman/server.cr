require "http/server"

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

    context.response.status_code = 200
    context.response.content_type = "text/plain"
    context.response.print("Hello!")
    context
  end
end

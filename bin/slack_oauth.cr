#! env crystal
require "../src/hangman"
require "json"

include Hangman

CLIENT_ID     = ENV["SLACK_CLIENT_ID"]
CLIENT_SECRET = ENV["SLACK_CLIENT_SECRET"]
REDIRECT_URI  = ENV["SLACK_REDIRECT_URI"]
SCOPES        = [
  "incoming-webhook",
  "commands",
  "chat:write:bot",
  "im:write",
]

authorize_uri = get_authorize_uri(SCOPES.join(" "))

puts "Visit this URL:"
puts
puts "    #{authorize_uri}"
puts

def get_authorize_uri(scope)
  query = HTTP::Params.build do |form|
    form.add "client_id", CLIENT_ID
    form.add "redirect_uri", REDIRECT_URI
    form.add "response_type", "code"
    form.add "scope", scope
  end

  URI.new("https", "slack.com", 443, "/oauth/authorize", query).to_s
end

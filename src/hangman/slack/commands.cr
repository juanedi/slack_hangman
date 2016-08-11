module Hangman::Slack::Commands
  extend self

  @@api = ::Slack::API.new(ENV["SLACK_OAUTH_TOKEN"])

  def handle(command)
    spawn { start_game(command) }
  end

  private def start_game(command)
    args = command.text.split(" ")

    if args.size > 1
      Slack::Message.new(text: "One word at a time please!")
                    .send_to_hook(command.response_url)
      return
    end

    word = args[0]
    game = Game.new(word)

    hint = game.hint.map { |c| c || '_' }.join(" ")

    attachments = [
      {
        text:            "The word looks something like this:\n`#{hint}`",
        attachment_type: "default",
        mrkdwn_in:       ["text"],
      },
      {
        text:            "Choose a letter:",
        attachment_type: "default",
        fallback:        "[hangman game]",
        callback_id:     "wopr_game",
        color:           "#3AA3E3",
        actions:         Game::VALID_CHARS.map { |c| {name: c.to_s, text: c.to_s, type: "button", value: c.to_s} },
      },
    ]

    message = Slack::Message.new(
      channel: command.channel_id,
      text: "@#{command.user_name} started a new hangman game!\n```#{game.draw}```",
      attachments: attachments.map { |a| JSON.parse(a.to_json) }
    )

    message.post_with_api(@@api)
  end
end

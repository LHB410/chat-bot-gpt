# @note: This service is used to call the OpenAI API to generate a response to a message
# @note: The API key is stored in the credentials file
# @param message [String] The message to generate a response for
# @param model [String] The model to use for the response [gpt-3.5-turbo, gpt-3.5-turbo-0301]
# @return [String] The generated response
# @example
#   ChatgptService.call('What is your name?', 'gpt-3.5-turbo')
#   => "\n\nI am an AI language model created by OpenAI, so I don't have a name. You can call me OpenAI or AI assistant."
# API Docs: https://platform.openai.com/docs/api-reference/chat/create
class ChatgptService
  include HTTParty

  attr_reader :api_url, :options, :model, :message

  def call
    body = {
      model: @model,
      messages: [{ role: 'user', content: message }],
      temperature: 0.4
    }

    response = HTTParty.post(api_url, body: body.to_json, headers: options[:headers], timeout: 10)
    raise response['error']['message'] unless response.code == 200

    response['choices'][0]['message']['content']
  end

  class << self
    def call(message, model = 'gpt-3.5-turbo')
      new(message, model).call
    end
  end

  private

  def initialize(message, model = 'gpt-3.5-turbo')
    api_key = ENV["CHAT_GPT_KEY"]
    @options = {
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{api_key}"
      }
    }
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @message = message
  end
end

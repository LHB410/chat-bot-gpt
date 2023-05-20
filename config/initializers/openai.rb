OpenAI.configure do |config|
    config.access_token = ENV.fetch('CHAT_GPT_KEY')
end

class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @chat = Chat.new
  end

  def create
    prompt = <<~PROMPT
      You are a DM of DnD 5e. You know all the rules. Scrape as much data as you can from the internet to be as knowledgable as you can about the rule set for 5e. You will answer questions related to dnd only. Nothing else. If you are asked a question that isn't dnd related respond with "I'm sorry, I only know about Dnd, perhaps ask another lore master your question". From Now please respond with "How can I answer your question adventurer?" and answer any further dnd related questions
    PROMPT
    @chat = Chat.new(chat_params)
    @init_response = ChatgptService.call(prompt)
    response = ChatgptService.call(@chat.message)

    if response.present?
      @chat.response = response
      if @chat.save
        render json: { chat: @chat }
      else
        render json: { error: 'Failed to save chat entry.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Failed to generate a response.' }, status: :unprocessable_entity
    end
  end



  def show
    @chat = Chat.find(params[:id])
    @chats = Chat.order(created_at: :asc)
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end
end

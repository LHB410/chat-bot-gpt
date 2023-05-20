class ChatsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
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

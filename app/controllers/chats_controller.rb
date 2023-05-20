class ChatsController < ApplicationController

  def index
    message = "how are you?"
    @response = ChatgptService.call(params[:message])
  end
end

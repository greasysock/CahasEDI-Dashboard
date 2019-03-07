class MessagesController < AuthApplicationController
    before_action :set_message, only: [:show]
    def index
        @messages = CahasEdi::Core.messages
    end

    def new
    end

    def create
    end

    def show
    end

    private

    def set_message
        @message = CahasEdi::Core.message params[:id]
    end
  end
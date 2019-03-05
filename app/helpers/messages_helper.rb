module MessagesHelper
    def messages_table
        if @messages
            out = ''
            @messages.each do |message|
                out<<render("messages/message_table", message: message)
            end
            out.html_safe
        end
    end
end

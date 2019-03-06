class MessagesPolicy < ApplicationPolicy
    def index?
        user.admin?
    end
end
class AdminDashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    def index
    end
    def create_user
    end
    def new_user
    end

    private
    def check_admin
        unless current_user.admin?
            redirect_to root_path, notice: "Authorization Needed"
        end
    end
end
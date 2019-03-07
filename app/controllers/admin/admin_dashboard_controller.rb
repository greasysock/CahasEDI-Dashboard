module Admin
    class AdminDashboardController < Admin::BaseController
        def index
            @users = User.all
        end

        def create_user
        end

        def new_user
        end

        def destroy_user
        end

        def edit_user
        end

        def update_user
        end
    end
end
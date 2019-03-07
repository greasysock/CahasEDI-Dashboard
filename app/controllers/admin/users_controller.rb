module Admin
    class UsersController < Admin::BaseController
        before_action :set_user, only: [:edit, :update, :destroy]
        def index
            @users = User.all
        end
        def show
        end
        def edit
        end
        def update
        end
        def new
            @user = User.new
        end
        def create
            puts '*'*200
            @user = User.new(user_params)
            
            respond_to do |format|
                if @user.save
                    format.html {redirect_to admin_users_path, notice: "User was successfully created."}
                else
                    format.html { render :new }
                end
            end
        end
        def destroy
        end
        private
        def set_user
            @user = User.find(params[:id])
        end

        def user_params
            params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        end
    end
end
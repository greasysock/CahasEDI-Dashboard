class RegistrationsController < Devise::RegistrationsController
    def new
        redirect_to root_path, notice: "Authorization Needed"
    end
    def create
        redirect_to root_path, notice: "Authorization Needed"
    end
end
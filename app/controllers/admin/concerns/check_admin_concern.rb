module Admin::Concerns::CheckAdminConcern
    extend ActiveSupport::Concern

    included do
        before_action :check_admin
    end

    def check_admin
        unless current_user.admin?
            redirect_to root_path, notice: "Authorization Needed"
        end
    end
    
end
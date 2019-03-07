module Admin
    class BaseController < AuthApplicationController
        include Admin::Concerns::CheckAdminConcern
    end
end
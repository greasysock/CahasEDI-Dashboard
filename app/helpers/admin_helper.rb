module AdminHelper
    def user_privileges user
        return content_tag(:span, "ADMIN", class: "badge badge-primary") if user.admin?
        content_tag(:span, "USER", class: "badge badge-secondary")
    end

    def user_status user
        content_tag(:span, "ACTIVE", class: "badge badge-success")
    end
end
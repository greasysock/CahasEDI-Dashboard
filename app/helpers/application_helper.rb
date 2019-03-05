module ApplicationHelper
    def active(path)
        if current_page?(path)
            "active"
        end
    end

    def navigation_items
        [
            {name: "Home", icon: "fa fa-home", link: root_path},
            {name: "Messages", icon: "fa fa-envelope", link: messages_path},
            {name: "Invoices", icon: "fa fa-book", link: invoices_path}
        ]
    end

    def navigation_bar_helper
        navigation_links = ''
        navigation_items.each do |item|
            navigation_links << content_tag(:li, class: "#{active(item[:link])}") do
                link_to item[:link], class: "navigation-item" do
                    content_tag(:i, nil, class: item[:icon]) +
                    content_tag(:span, item[:name])
                end
            end
        end
        navigation_links.html_safe
    end

    def alert message
        render("shared/alert", msg: message)
    end
end

module ApplicationHelper
    def active(path)
        if current_page?(path)
            "active"
        end
    end

    def parent_active parent, children
        if current_page?(parent[:link])
            return true
        end
        children.each do |child|
            if current_page?(child[:link])
                return true
            end
        end
        return false
    end

    def format_navigation_parent nav_parent
        act = parent_active(nav_parent.parent_item, nav_parent.children)
        out = ''
        out << content_tag(:li, class: "treeview #{"active" if act}") do
            link_to("#") do
                content_tag(:i, nil, class: nav_parent.parent_item[:icon]) +
                content_tag(:span, nav_parent.parent_item[:name]) +
                content_tag(:span, nil,class:"pull-right-container") do
                    content_tag(:i, nil,class: "fa fa-angle-left pull-right")
                end
            end +
            content_tag(:ul, class: "treeview-menu") do
                inner_stuff = ''
                inner_stuff<<content_tag(:li, class:"#{ active nav_parent.parent_item[:link] }") do
                    link_to("Dashboard", nav_parent.parent_item[:link])
                end
                nav_parent.children.each do |child|
                    inner_stuff<<content_tag(:li, class:"#{ active child[:link] }") do
                        link_to(child[:name], child[:link])
                    end
                end
                inner_stuff.html_safe
            end
        end
        out
    end

    class NavigationParent
        def initialize(parent_item, children)
            @parent_item = parent_item
            @children = children
        end
        def parent_item
            @parent_item
        end
        def children
            @children
        end
    end

    def navigation_items
        [
            {name: "Home", icon: "fa fa-home", link: root_path},
            NavigationParent.new( {name: "Partnerships", icon: "fa fa-users", link: partnerships_path}, 
                [ {name: "New Partnership", icon: "fa fa-plus", link: new_partnership_path } ]),
            {name: "Messages", icon: "fa fa-envelope", link: messages_path},
            NavigationParent.new( {name: "Invoices", icon: "fa fa-book", link: invoices_path}, 
                [ {name: "New Invoice", icon: "fa fa-plus", link: new_invoice_path } ]),
            NavigationParent.new({name: "Purchase Orders", icon: "fa fa-shopping-cart", link: purchase_orders_path}, 
                [ {name: "New Purchase Order", icon: "fa shopping-cart", link: new_purchase_order_path } ])
        ]
    end

    def navigation_bar_helper
        navigation_links = ''
        navigation_items.each do |item|
            if item.class == Hash
                navigation_links << content_tag(:li, class: "#{active(item[:link])}") do
                    link_to item[:link], class: "navigation-item" do
                        content_tag(:i, nil, class: item[:icon]) +
                        content_tag(:span, item[:name])
                    end
                end
            elsif item.class == NavigationParent
                navigation_links << format_navigation_parent(item)
            end
        end
        navigation_links.html_safe
    end

    def alert message
        render("shared/alert", msg: message)
    end
end

module InvoicesHelper
    def invoices_table
        if @invoices.content
            out = ''
            @invoices.content.each do |invoice|
                out<<render("invoices/invoice_table", message: invoice)
            end
            out.html_safe
        end
    end

    def page_active page
        return 'active' if page == @messages.page
    end

    def invoices_paginator pages_visible = 3

        # Checks if pages is less than pages_visible to determine the amount of links needed
        pages_visible = @messages.pages if @messages.pages < pages_visible
        out = ''
        out << content_tag(:nav) do
            content_tag(:ul, class:"pagination") do
                inner = ''
                pages_visible.times do |page|
                    page += 1 if @messages.page == 1
                    page += -1 if @messages.page == @messages.pages
                    page += @messages.page
                    if page > 1
                        page += -1
                    end
                    if page <= @messages.pages
                        inner << content_tag(:li, class:"page-item #{page_active page}") do
                            link_to page, "#{messages_path}?p=#{page}", class: "page-link"
                        end
                    end
                    inner
                end
                inner.html_safe
            end
        end
        out.html_safe
    end
end

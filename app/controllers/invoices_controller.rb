class InvoicesController < AuthApplicationController
    before_action :set_invoice, only: [:show]
    def index
        @invoice_page = params[:p]
        @invoices = CahasEdi::Core.invoices @invoice_page
    end

    def new
    end

    def create
    end

    def show
    end

    private

    def set_invoice
        @invoice = CahasEdi::Core.invoice params[:id]
    end
end
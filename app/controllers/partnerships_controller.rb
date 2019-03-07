class PartnershipsController < AuthApplicationController
    def index
        @partnerships = CahasEdi::Core.partners
    end

    def new
    end

    def create
    end

    def show
    end
end
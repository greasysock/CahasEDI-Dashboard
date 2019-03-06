class ApplicationController < ActionController::Base
    include DeviseWhitelist
    include Pundit
    
end

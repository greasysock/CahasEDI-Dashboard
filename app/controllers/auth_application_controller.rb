class AuthApplicationController < ApplicationController
    before_action :authenticate_user!
end
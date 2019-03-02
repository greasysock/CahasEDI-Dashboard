class PageController < ApplicationController
  before_action :authenticate_user!
  def home
  end
  def messages
  end
  def invoices
  end
end

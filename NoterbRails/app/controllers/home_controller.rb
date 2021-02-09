class HomeController < ApplicationController
  # include Devise::Controllers::Helpers
  def index
    @user = current_user
  end
end

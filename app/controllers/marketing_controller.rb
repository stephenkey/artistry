class MarketingController < ApplicationController
  before_action :check_for_user

  def index
    @user = User.new
  end

  private

  def check_for_user
    if user_signed_in?
      redirect_to '/albums/mine'
    end
  end
end

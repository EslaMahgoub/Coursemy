class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  after_action :user_activity  
  include Pundit

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    
  include PublicActivity::StoreController #store the user that made any changes to the course model
  
  before_action :set_global_action, if: :user_signed_in?
  def set_global_action
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end
    

  private

  def user_not_authorized #pundit
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
  
  def user_activity
    current_user.try :touch #update user to show his last time online
  end
  
  
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  before_action :set_global_action, if: :user_signed_in?
  def set_global_action
    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end
    
  include PublicActivity::StoreController #store the user that made any changes to the course model
  
end

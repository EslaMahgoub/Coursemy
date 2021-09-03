class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  def index
    # using scopes to move the logic to models instead of controllers
    @courses = Course.all.limit(3)
    @latest_courses = Course.latest_courses
    @latest_good_reviews = Enrollment.reviewed.latest_good_reviews
    
    @popular_courses = Course.popular_courses
    @top_rated_courses = Course.top_rated_courses
    @purchased_courses = Course.all.limit(3).joins(:enrollments).where(enrollments: {user: current_user}).order(created_at: :desc)
    
  end

  def privacy_policy
  end
  
  def activity
    @activities = PublicActivity::Activity.all
  end
  
end

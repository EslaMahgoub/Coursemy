class Courses::CourseWizardController < ApplicationController
  include Wicked::Wizard
  before_action :set_progress, only: %i[show update]
  before_action :set_course, only: %i[show update finish_wizard_path]
  

  steps :basic_info, :details
  
  def show
    case step
    when :basic_info
    when :details
      @tags = Tag.all
    end
    render_wizard
  end
  
  def update
    case step
    when :basic_info
      @course.update(course_params)
    
    when :details
      @course.update(course_params)
      @tags = Tag.all
    end
    # go to next page
    render_wizard @course 
  end
  
  def finish_wizard_path
    
    course_path(@course)
  end
  
  private
    def set_progress
      if wizard_steps.any? && wizard_steps.index(step).present?
        @progress = ((wizard_steps.index(step) + 1).to_d / wizard_steps.count.to_d) * 100
      else
        @progress = 0
      end
    end
    
    def set_course
      @course = Course.friendly.find(params[:course_id])
    end
    
    def course_params
      params.require(:course).permit(:title, :description, :short_description, :language, :level, :price, :published, :avatar, tag_ids: [])
    end
end

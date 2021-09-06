module ApplicationHelper
  include Pagy::Frontend
  
  
  # create dynamic labels based on crud action
  def crud_label(key)
    case key
      when 'create'
        "<i class='fas fa-plus'></i>".html_safe
      when 'update'
        "<i class='fas fa-pen'></i>".html_safe
      when 'destroy'
        "<i class='fas fa-trash'></i>".html_safe
    end
  end
  
  # create dynamic labels based on model
  def model_label(model)
    case model
      when 'Course'
        "<i class='fas fa-graduation-cap'></i>".html_safe
      when 'Lesson'
        "<i class='fas fa-tasks'></i>".html_safe
      when 'Enrollment'
        "<i class='fas fa-lock-open'></i>".html_safe
      when 'Comment'
        "<i class='fas fa-comment'></i>".html_safe
    end
  end
  
  
  
end

module CoursesHelper
  def enrollment_button(course)
    if current_user
      if course.user == current_user
        link_to "You created this course. View Statistics", course_path(course)
      elsif course.enrollments.where(user_id: current_user).any?
        link_to  course_path(course) do 
          "<i class='fas fa-spinner'></i>".html_safe + " " +      
          number_to_percentage(course.progress(current_user), precision: 0) # precision 0 to remove zeros after the dot 100.000% -> 100%
        end
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: "btn btn-md btn-success"
      else
        link_to "Free", new_course_enrollment_path(course), class: "btn btn-md btn-success" 
      end
    else
      link_to "Check Price", new_course_enrollment_path(course), class: "btn btn-md btn-success"
    end
  end
  
  def review_button(course)
    user_course = course.enrollments.where(user: current_user)
    if current_user
      if user_course.any?
        if user_course.pending_review.any?
          link_to edit_enrollment_path(user_course.first) do
            "<i class='text-warning fas fa-star'></i>".html_safe + "" +      
            "<i class='text-dark fas fa-question'></i>".html_safe + "" +     
            "Add a review"
          end
        else
          link_to enrollment_path(user_course.first) do 
            "<i class='text-warning fas fa-star'></i>".html_safe + " " +      
            "<i class='text-dark fas fa-check'></i>".html_safe + " " +     
            "Thanks for your review! Check Your Review"
          end
        end
      end
    end
  end
end

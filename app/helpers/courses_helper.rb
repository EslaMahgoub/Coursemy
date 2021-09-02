module CoursesHelper
  def enrollment_button(course)
    if current_user
      if course.user == current_user
        link_to "You created this course. View Statistics", course_path(course)
      elsif course.enrollments.where(user_id: current_user).any?
        link_to "You already enrolled in this course. Continue Learning", course_path(course)
      elsif course.price > 0
        link_to number_to_currency(course.price), new_course_enrollment_path(course), class: "btn btn-md btn-success"
      else
        link_to "Free", new_course_enrollment_path(course), class: "btn btn-md btn-success" 
      end
    else
      link_to "Check Price", course_path(course), class: "btn btn-md btn-success"
    end
  end
end

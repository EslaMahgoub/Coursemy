class EnrollmentMailer < ApplicationMailer
  
  def new_enrollment(enrollment)
    @enrollment = enrollment
    @course  = @enrollment.course
    mail(to: @enrollment.user.email, subject: "You have been enrolled to: #{@course}")
    # mail(to: @enrollment.course.user.email, subject: "You have a new student enrolled in: #{@course}")
  end
  
end

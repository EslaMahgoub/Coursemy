# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  
  def new_user
    UserMailer.new_user(User.order(created_at: :desc).first).deliver_now
  end
  
end

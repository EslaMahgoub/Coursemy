class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]
  
  rolify
  
  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first

    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(
            email: data['email'],
            password: Devise.friendly_token[0,20],
            confirmed_at: Time.now
        )
    end
    user
end
         
  def to_s
    email
  end
  
  def username
    self.email.split(/@/).first
  end
  
  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  
  extend FriendlyId
  friendly_id :email, use: :slugged   # use email as slug
  
  after_create :assign_default_role

  def assign_default_role
    # If first User of the system, he will be an admin, otherwise he will be a teacher and a studnet
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
    self.add_role(:student) if self.roles.blank?
    self.add_role(:teacher)
    end
  end
  
  def view_lesson(lesson)
    user_lesson = self.user_lessons.where(lesson: lesson)
    unless user_lesson.any?  #unless = if not 
      self.user_lessons.create(lesson: lesson)
    else
      user_lesson.first.increment!(:impressions)
    end
  end
  def online?
    updated_at > 2.minutes.ago
  end
  
  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end
  
  #make sure that each user on the system has at least one roll
  validate :must_have_a_role, on: :update
  
  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "Must have at least one role")
    end
  end
  
  
  
end

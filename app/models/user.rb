class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
  
  rolify
         
  def to_s
    email
  end
  
  def username
    self.email.split(/@/).first
  end
  
  has_many :courses
  has_many :enrollments
  
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

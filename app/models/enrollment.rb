class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :enrollments) }  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :enrollments) }  
  
  validates_presence_of :review, if: :rating?
  validates_presence_of :rating, if: :review?
  \
  
  validates_uniqueness_of :course_id, scope: :user_id  #user cannot subscribe to same course twice
  validates_uniqueness_of :user_id, scope: :course_id  #user cannot subscribe to same course twice
  
  validate :cant_subscribe_to_own_course   # user cannot subscribe to his own courses
  
  scope :pending_review, -> {where(rating: [0, nil, ""], review: [0, nil, ""])}
  
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  
  def to_s
    user.to_s + " " + course.to_s
  end
  
  after_save do
    unless  rating.nil? || rating.zero?
      course.update_rating
    end
  end
  
  after_destroy do 
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end
  
  protected
  def cant_subscribe_to_own_course
    if self.new_record? #when creating a new enrollment check for the user_id
      if self.user_id.present?
        if user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end
end

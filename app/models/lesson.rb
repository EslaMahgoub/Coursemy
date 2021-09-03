class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :lessons) } # counter cache for old records
  validates :title, :content, :course, presence: true
  
  has_many :user_lessons
  
  has_rich_text :content
  extend FriendlyId
  friendly_id :title, use: :slugged   # use title as slug
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  
  def to_s
    title
  end
  
  def viewed(user)
    unless user == self.course.user # if user != self.course.user
      self.user_lessons.where(user: user).present?
    # self.user_lessons.where(user_id: user.id, lesson: self.id).present?
    end
  end
end

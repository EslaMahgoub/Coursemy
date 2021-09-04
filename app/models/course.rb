class Course < ApplicationRecord
  validates :title, :short_description, :language, :level, :price, presence: true
  validates :description, presence: true, length: { :minimum => 5} 
  
  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :courses) }  counter cache for old records
  has_many :lessons, dependent: :destroy   #destroy lessons when course is destroyed
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons # get user_lessons related to lessons 
  
  validates :title, uniqueness: true
  
  def to_s
    title
  end
  
  def progress(user)
    unless self.lessons.count == 0 #if self.lessons.count != 0
      user_lessons.where(user: user).count / self.lessons.count.to_f * 100
    end
  end
  
  scope :latest_courses, -> { limit(3).order(created_at: :desc) } 
  scope :popular_courses, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :top_rated_courses, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  
  has_rich_text :description
  extend FriendlyId
  friendly_id :title, use: :slugged   # use title as slug
  
  # friendly_id :generated_slug, use: :slugged  #generate random slug, better for transactions
  # def generated_slug
  #   require 'securerandom'
  #   @random_slug ||= persisted? ? friendly_id : SecureRandom.hex(4)
  # end 
  
  # def to_s
  #   slug
  # end
  LANGUAGES = [:"Arabic", :"English", :"Polish", :"Russian", :"Spanish"]
  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end 
  
  LEVELS = ["Beginner", "Intermediate", "Advanced"]
  def self.levels
    LEVELS.map { |level| [level,level] }
  end 
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  
  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end
  
  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)  # update_column(name, value)
    else
      update_colum :average_rating, (0)
    end
      
  end
  
end

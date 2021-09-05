class Lesson < ApplicationRecord
  belongs_to :course, counter_cache: true
  #Course.find_each { |course| Course.reset_counters(course.id, :lessons) } # counter cache for old records
  validates :title, :content, :course, presence: true
  
  validates :title, length: { :maximum => 70}
  
  validates_uniqueness_of :title, scope: :course_id
  # validates :video_thumbnail, presence: true, if: :video_present?
  
  # def video_present?
  #   self.video.present?
  # end
  
  has_many :user_lessons, dependent: :destroy
  
  has_one_attached :video
  has_one_attached :video_thumbnail
  validates :video,
    content_type: ['video/mp4'], 
    size: { less_than: 50.megabytes , message: 'size should be under 50 megabytes' }
  validates :video_thumbnail,
    content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
    size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }
  
  
  has_rich_text :content
  extend FriendlyId
  friendly_id :title, use: :slugged   # use title as slug
  
  include RankedModel
  ranks :row_order, with_same: :course_id
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  
  
  def to_s
    title
  end
  
  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end
  
  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end
  
  def viewed(user)
    unless user == self.course.user # if user != self.course.user
      self.user_lessons.where(user: user).present?
    # self.user_lessons.where(user_id: user.id, lesson: self.id).present?
    end
  end
end

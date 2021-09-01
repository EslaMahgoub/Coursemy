class Lesson < ApplicationRecord
  belongs_to :course
  validates :title, :content, :course, presence: true
  
  has_rich_text :content
  extend FriendlyId
  friendly_id :title, use: :slugged   # use title as slug
  
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user}
  
  def to_s
    title
  end
end

class UserLesson < ApplicationRecord
  
  belongs_to :user
  belongs_to :lesson
  
  validates :user, :lesson, presence: true
  
  validates_uniqueness_of :lesson_id, scope: :user_id  #user cannot see same lesson twice for first time 
  validates_uniqueness_of :user_id, scope: :lesson_id 
  
end
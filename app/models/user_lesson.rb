class UserLesson < ApplicationRecord
  # To Track the user with lesson in terms of viewed or not and impressions count
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :user_lessons) }  counter cache for old records
  belongs_to :lesson, counter_cache: true
  #Lesson.find_each { |lesson| Lesson.reset_counters(lesson.id, :user_lessons) }  counter cache for old records
  
  validates :user, :lesson, presence: true
  
  validates_uniqueness_of :lesson_id, scope: :user_id  #user cannot see same lesson twice for first time 
  validates_uniqueness_of :user_id, scope: :lesson_id 
  
end
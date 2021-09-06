class Comment < ApplicationRecord
  
  belongs_to :user, counter_cache: true
  #User.find_each { |user| User.reset_counters(user.id, :comments) }  counter cache for old records
  belongs_to :lesson, counter_cache: true
  #Lesson.find_each { |lesson| Lesson.reset_counters(lesson.id, :comments) }  counter cache for old records
  validates :content, presence: true
end
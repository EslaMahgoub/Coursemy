# User.create!(email: "admin@admin.com", password: "admin@admin.com", password_confirmation: "admin@admin.com")

30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    short_description: Faker::Quote.famous_last_words,
    user_id: User.first.id,
    language: "English",
    level: "Beginner",
    price: Faker::Number.between(from: 10, to: 100), 
  }])
end
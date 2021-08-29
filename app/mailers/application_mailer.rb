class ApplicationMailer < ActionMailer::Base
  default from: 'support@coursemy.herokuapp.com'
  layout 'mailer'
end

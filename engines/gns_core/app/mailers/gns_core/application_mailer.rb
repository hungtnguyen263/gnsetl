module GnsCore
  class ApplicationMailer < ActionMailer::Base
    default from: ENV['gmail_username']
    layout 'mailer'
    
    private
    def send_email(email, subject)
      delivery_options = {
        address: 'smtp.gmail.com',
        port: 587,
        domain: 'globalnaturesoft.com',
        user_name: ENV['gmail_username'],
        password: ENV['gmail_password'],
        authentication: 'plain',
        enable_starttls_auto: true
      }
      mail(to: email,
           subject: subject,
           delivery_method_options: delivery_options)
    end
  end
end

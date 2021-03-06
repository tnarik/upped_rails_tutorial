class UserMailer < ActionMailer::Base
  default :from => "defaultfrom@upped.me"

  def signup_confirmation(user)
    @user = user
    attachments.inline["rails.png"] = File.read("#{Rails.root}/app/assets/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Please verify your e-mail address to access: Tnarik's great app", :from => "registrations@upped.me")
  end

  def password_reset(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Tnarik's great app: password reset", :from => "admin@upped.me")
  end
end
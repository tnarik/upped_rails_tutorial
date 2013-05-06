class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "intercepted '#{message.subject}' mailed to '#{message.to}'"
    message.to = "tnarik@gmail.com"
  end
end
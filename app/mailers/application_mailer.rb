# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'mikhaylov.av22@gmail.com'
  layout 'mailer'
end

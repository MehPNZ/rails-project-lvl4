class UserMailer < ApplicationMailer
  
  def check_email
    @email = params[:email]
    mail(to: @email, subject: 'Github quality')
  end

end

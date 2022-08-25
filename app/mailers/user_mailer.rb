class UserMailer < ApplicationMailer
  
  def check_email
    @check = params[:check]
    @email = @check.repository.user.email

    mail(to: @email, subject: "Github quality check repository \"#{@check.repository.link}\"")
  end

end

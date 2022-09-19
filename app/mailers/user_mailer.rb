# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def check_email
    @check = params[:check]
    @email = @check.repository.user.email

    mail(to: @email, subject: "#{t('subject_mail')} \"#{@check.repository.full_name}\"")
  end
end

# frozen_string_literal: true

module GithubService
  extend ActiveSupport::Concern
  def login_via_github!(auth)
    email = auth[:info][:email].downcase
    nickname = auth[:info][:nickname]
    token = auth[:credentials][:token]

    existing_user = User.find_or_create_by(email: email) do |user|
      user.nickname = nickname
    end
    existing_user.update(token: token)
    existing_user
  end
end

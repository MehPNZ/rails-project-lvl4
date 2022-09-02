# frozen_string_literal: true

class RepositoryLoaderStub
  def self.octokit_client(_); end

  def self.get_repo(_)
    {
      name: 'First',
      language: 'Ruby',
      repo_created_at: '11-11-2021',
      repo_updated_at: '11-11-2021'
    }
  end

  def self.create_hook(_); end

  def self.get_repos(_client)
    [{ id: 502_905_064, full_name: 'MehPNZ/ruby-gems', language: 'Ruby' },
     { id: 504_422_113, full_name: 'MehPNZ/simple_form', language: 'Javascript' }]
  end

  # def self.authenticate_user(session)
  #   # auth_hash = Faker::Omniauth.github
  #   # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
  #   # # callback_auth_path('github')  
  #   user = User.new(email: "test@test.com", nickname: "test", token: "qwdasdqdw3423424")
  #   user.save
  #   debugger
  #   session[:user_id] = user.id
  # end

end

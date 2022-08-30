# frozen_string_literal: true

class AuthOmniStub
  def self.request_omniauth(_)
    {
      info: {
        email: 'test@test.test',
        nickname: 'Testovich'
      },
      credentials: {
        token: 'qwertyuiopdsasdfghjklfszxcvbnmvd123456'
      }
    }
  end
end

class AuthOmniStub
  def self.request_omniauth(auth)
    auth = {
      info: {
        email: "test@test.test",
        nickname: "Testovich"
      },
      credentials: {
        token: 'qwertyuiopdsasdfghjklfszxcvbnmvd123456'
      }
    }
  end
end
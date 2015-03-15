module OmniauthMacros
  def mock_auth_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '1234567',
      :info => {
        :email => 'john@doe.com',
        :first_name => 'John',
        :last_name => 'Doe'
      },
      :extra => {
        :raw_info => {
          :gender => 'male'
        }
      }
    })
  end
end

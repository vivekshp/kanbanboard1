module AuthHelper
    def sign_in(user)
      token = JwtService.encode(user_id: user.id)
      cookies[:jwt] = token
    end
  end
  
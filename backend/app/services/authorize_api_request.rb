class AuthorizeApiRequest
    def initialize(headers = {})
      @headers = headers
    end
    
    def call
      {
        user: user
      }
    end
    
    private
    
    attr_reader :headers
    
    def user
      @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
      @user || raise('Invalid token')
    end
    
    def decoded_auth_token
      @decoded_auth_token ||= JwtService.decode(http_auth_header)
    end
    
    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
      elsif headers['Cookie'].present?
        cookie_match = headers['Cookie'].match(/jwt=([^;]+)/)
        return cookie_match[1] if cookie_match
      end
      raise('Missing token')
    end
  end
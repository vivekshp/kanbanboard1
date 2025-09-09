class AuthenticationController < ApplicationController
    include ActionController::Cookies
    skip_before_action :authenticate_request, only: [:register, :login, :logout]
    def register
      @user = User.create(user_params)
      if @user.valid?
        token = JwtService.encode(user_id: @user.id)
        set_jwt_cookie(token)
        render json: { user: @user.as_json(except: :password_digest), message: 'User created successfully' }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def login
      @user = User.find_by(email: params[:email])
      if @user&.authenticate(params[:password])
        token = JwtService.encode(user_id: @user.id)
        set_jwt_cookie(token)
        render json: { user: @user.as_json(except: :password_digest), message: 'Login successful' }
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
    
    def logout
      delete_jwt_cookie
      render json: { message: 'Logged out successfully' }
    end

    def me
      if current_user
        render json: { user: current_user.as_json(except: :password_digest) }
      else
        render json: { error: 'Not logged in' }, status: :unauthorized
      end
    end
    
    
    private
    
    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_jwt_cookie(token)
      cookies[:jwt] = {
        value: token,
        httponly: true,
        secure: true,
        same_site: :none,
        expires: 24.hours.from_now
      }
    end
    
    def delete_jwt_cookie
      cookies.delete(:jwt)
    end
  end
class AuthenticationController < ApplicationController
    include ActionController::Cookies
    include TenantHelper

    skip_before_action :authenticate_request, only: [:register, :login, :logout]
    
    
    def register
     tenant_name = extract_tenant_name(params[:email])
     tenant = Tenant.find_by(name: tenant_name)
     unless tenant
       return render json: { errors: ["Tenant '#{tenant_name}' not found. Contact admin."] }, status: :unprocessable_entity
     end

     user = nil
     Apartment::Tenant.switch(tenant.db_name) do
      user = User.new(user_params)
      unless user.save
        return render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
     end
         

         token = JwtService.encode(user_id: user.id, tenant: tenant.db_name)
         set_jwt_cookie(token)
         render json: { user: user.as_json(except: :password_digest), message: 'User created successfully' }, status: :created
      
    end
    
    def login
    tenant_name = extract_tenant_name(params[:email])
    tenant = Tenant.find_by(name: tenant_name)
    unless tenant
      return render json: { error: 'Tenant not found' }, status: :unauthorized
    end

    user = nil
    Apartment::Tenant.switch(tenant.db_name) do
      user = User.find_by(email: params[:email])
      unless user&.authenticate(params[:password])
        return render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end

    token = JwtService.encode(user_id: user.id, tenant: tenant.db_name)
    set_jwt_cookie(token)
    render json: { user: user.as_json(except: :password_digest), message: 'Login successful' }
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
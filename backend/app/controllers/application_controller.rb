class ApplicationController < ActionController::API
  include Pundit::Authorization
    around_action :switch_tenant
    before_action :authenticate_request
    

    rescue_from Pundit::NotAuthorizedError do
      render json: { success: false, errors: ['Not authorized'] }, status: :forbidden
    end


    
    
    private

    def auth_token_from_request
     if request.headers['Authorization'].present?
       return request.headers['Authorization'].split(' ').last
     elsif request.headers['Cookie'].present?
       cookie_match = request.headers['Cookie'].match(/jwt=([^;]+)/)
     return cookie_match[1] if cookie_match
     end
       raise('Missing token')
    end
    
    def authenticate_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
      Current.user = @current_user
    rescue StandardError => e
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    
    def current_user
      @current_user
    end

    def render_success(data, status: :ok)
      render json: { success: true, data: data }, status: status
    end
  
    def render_error(errors, status: :unprocessable_content)
      render json: { success: false, errors: Array(errors) }, status: status
    end


    def switch_tenant(&block)
     tenant_db = nil

     token = auth_token_from_request rescue nil
     if token
     payload = JwtService.decode(token) rescue nil
     tenant_db = payload && (payload['tenant'] || payload[:tenant])
     end

     if tenant_db.blank? && params[:email].present?
     tenant_name = params[:email].to_s.split('@').last.split('.').first.downcase
     tenant = Tenant.find_by(name: tenant_name)
     tenant_db = tenant&.db_name
  end

  Rails.logger.info ">>> Switching tenant: #{tenant_db || 'default (no tenant)'}"

  if tenant_db.present?
    Apartment::Tenant.switch(tenant_db, &block)
  else
    yield
  end
end

end

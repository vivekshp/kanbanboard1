class ApplicationController < ActionController::API
    before_action :authenticate_request
    
    private
    
    def authenticate_request
      @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
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
    
  end
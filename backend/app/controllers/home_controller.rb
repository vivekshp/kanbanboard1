class HomeController < ApplicationController
  skip_before_action :authenticate_request, only: [:index]
  skip_around_action :switch_tenant, only: [:index]
  def index
       @initial_data = {
      current_user: {name: "John Doe"}
    }
  end
end

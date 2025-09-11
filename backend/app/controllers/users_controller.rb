class UsersController < ApplicationController
    def search
        q = params[:q].to_s.strip.downcase
        return render_success([]) if q.blank?
      
         users = User.where(
          '(LOWER(name) LIKE ? OR LOWER(email) LIKE ?) AND id != ?',
          "%#{q}%", "%#{q}%", current_user.id
        ).limit(10)
      
        render_success(users.as_json(only: [:id, :name, :email]))
      end
      
  end

  
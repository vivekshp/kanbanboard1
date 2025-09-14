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
        
     def search_board_members
        board = Board.find(params[:board_id])
       q = params[:q].to_s.strip.downcase
       return render_success([]) if q.blank?

       users = board.board_members
       .where(status: "accepted")
       .where.not(user_id: current_user.id)
       .joins(:user)
       .where('LOWER(users.name) LIKE ? OR LOWER(users.email) LIKE ?', "%#{q}%", "%#{q}%")
       .limit(10)
       .map(&:user)

        render_success(users.as_json(only: [:id, :name, :email]))
     end
end

    
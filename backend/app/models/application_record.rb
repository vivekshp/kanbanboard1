class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

   def log_history(action:, user_id: nil, modified_to: nil, time: Time.current)
    History.create!(
      record_type: self.class.name,
      record_id: self.id,
      action: action,
      modified_by: user_id,
      time: time,
      modified_to: modified_to
    )
  end
end

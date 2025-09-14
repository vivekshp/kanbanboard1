class User < ApplicationRecord
    has_secure_password
    
    has_many :boards, dependent: :destroy
    has_many :board_members, dependent: :destroy
    has_many :task_assignments, dependent: :destroy
    has_many :assigned_tasks, through: :task_assignments, source: :task

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
    
    before_save :downcase_email

    private
    
    def downcase_email
      self.email = email.downcase
    end
  end
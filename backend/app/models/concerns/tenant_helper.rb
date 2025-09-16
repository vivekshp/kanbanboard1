module TenantHelper
  extend ActiveSupport::Concern

  def extract_tenant_name(email)
    email.split('@').last.split('.').first.downcase
  end
end
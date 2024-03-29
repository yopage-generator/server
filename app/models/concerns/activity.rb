module Activity
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where is_active: true }
  end

  def deactivate!
    update_attribute :is_active, false
  end

  def activate!
    update_attribute :is_active, true
  end
end

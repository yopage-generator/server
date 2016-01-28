class AssetFile < ActiveRecord::Base
  belongs_to :account
  belongs_to :landing
  belongs_to :landing_version

  scope :ordered, -> { order :id }
end

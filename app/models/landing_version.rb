class LandingVersion < ActiveRecord::Base
  include Activity

  belongs_to :landing, counter_cache: :versions_count
  has_many :sections, dependent: :destroy
  has_many :collection_items

  has_one :account, through: :landing

  scope :ordered, -> { order :id }

  def full_title
    "#{landing} / #{to_s}"
  end

  def to_s
    title.presence || I18n.l(updated_at, format: :short)
  end
end

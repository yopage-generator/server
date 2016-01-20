class Landing < ActiveRecord::Base
  belongs_to :account, counter_cache: true

  has_many :collections
  has_many :versions, class_name: 'LandingVersion'

  validates :title, presence: true

  def to_s
    title
  end
end

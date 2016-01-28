class Section < ActiveRecord::Base
  # include RankedModel

  serialize :data_serialized, JSON

  belongs_to :landing_version

  belongs_to :background_image, class_name: 'AssetImage'

  scope :ordered, -> { order :row_order }

  alias_attribute :data, :data_serialized
end

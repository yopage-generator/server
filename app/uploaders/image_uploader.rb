class ImageUploader < FileUploader
  # process :convert => 'png'
  include CarrierWave::MiniMagick
  EXTENSION_WHITE_LIST = %w(jpg jpeg gif png svg).freeze

  def extension_white_list
    EXTENSION_WHITE_LIST
  end

  def mandatory_file
    if file.present?
      file.file
    else
      Rails.root.join 'public/images/fallback/product-none.png'
    end
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def height
    geometry.second
  end

  def width
    geometry.first
  end

  def geometry
    @geometry ||= ::MiniMagick::Image.open(file.file)[:dimensions]
  rescue => err
    Bugsnag.notify err, metaData: { model: model, file: file.file }
    [nil, nil]
  end

  def rotate!(_grad = 90)
    manipulate! do |img|
      img.rotate 90
      img
    end
    # i = MiniMagick::Image.new image.file.file
    # i.rotate grad
    recreate_versions!
    model.save!
  end

  def adjusted_url(width: nil, height: nil, size: nil, filters: [])
    if size.present?
      width = size
      height = size
    end

    params = {}
    params[:width] = width if width.present?
    params[:height] = height if height.present?
    params[:filters] = filters if filters.present?
    ThumborService.new(self).url params
  end

  def default_url
    ActionController::Base.helpers.asset_url Settings.fallback_image
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) || model.instance_variable_set(var, SecureRandom.uuid)
  end
end

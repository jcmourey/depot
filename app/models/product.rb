class Product < ActiveRecord::Base
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
      with:     %r{\.(gif|jpg|png)\Z}i,
      message:  I18n.translate('errors.messages.must_be_url_for_gif_or_jpg_or_png')
  }
end

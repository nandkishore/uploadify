class Photo < ActiveRecord::Base
  attr_accessible :image, :sku_id
  belongs_to :sku
  mount_uploader :image, PhotoUploader
end

class Sku < ActiveRecord::Base
  attr_accessible :code
  validates :code, :uniqueness => true
  has_many :photos,  :dependent => :destroy
end

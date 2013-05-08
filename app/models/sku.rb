class Sku < ActiveRecord::Base
  attr_accessible :code
  validates :code, :uniqueness => true
end

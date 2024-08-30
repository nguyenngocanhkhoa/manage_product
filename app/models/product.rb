class Product < ApplicationRecord
  validates :title, :content, presence: true
end

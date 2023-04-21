class Room < ApplicationRecord
  belongs_to :hall
  has_many :user

end

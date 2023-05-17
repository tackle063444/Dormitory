
class Hall < ApplicationRecord
  has_many :rooms
  mount_uploader :hall_logo, HallLogoUploader
end

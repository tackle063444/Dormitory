class User < ApplicationRecord
    has_many :rents
    #has_many :user_logs, dependent: :destroy
  end
   
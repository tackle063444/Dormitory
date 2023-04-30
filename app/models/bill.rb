class Bill < ApplicationRecord
  belongs_to :rent, optional: true
  belongs_to :bill_list, optional: true
  belongs_to :hall, optional: true

  attr_accessor :form_select
end

class Workout < ApplicationRecord
  belongs_to :user
  has_many :exercises, dependent: :destroy

  accepts_nested_attributes_for :exercises, allow_destroy: true

end

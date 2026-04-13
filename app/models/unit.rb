class Unit < ApplicationRecord
  # O Rails é sensível a letras maiúsculas e nomes no singular!
  belongs_to :block
  has_many :user_units, dependent: :destroy
  has_many :users, through: :user_units
  has_many :tickets
end
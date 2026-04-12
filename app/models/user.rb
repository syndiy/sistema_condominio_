class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # A forma correta no Rails atual:
  enum :role, { admin: 0, colaborador: 1, morador: 2 }, default: :morador

  has_many :user_units
  has_many :units, through: :user_units
  has_many :tickets
  has_many :comments
end
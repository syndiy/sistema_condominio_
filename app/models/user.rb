class User < ApplicationRecord
  # ESSA LINHA É OBRIGATÓRIA para o login funcionar:
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  
  # O resto das suas configurações:
  enum :role, { morador: 0, colaborador: 1, admin: 2 }

  has_many :user_units, dependent: :destroy
  has_many :units, through: :user_units
  has_many :tickets, dependent: :destroy
end
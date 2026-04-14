class User < ApplicationRecord
  # Devise padrão
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  
  # Roles
  enum :role, { morador: 0, colaborador: 1, admin: 2 }

  # Associações
  has_many :user_units, dependent: :destroy
  has_many :units, through: :user_units
  has_many :tickets, dependent: :destroy

  # --- AQUI ESTAVA O ERRO (Ajustado para Português como seu Model) ---
  has_many :responsabilidades, dependent: :destroy
  has_many :ticket_types, through: :responsabilidades
end
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable
  
  enum :role, { morador: 0, colaborador: 1, admin: 2 }

  # Associações de Morador
  has_many :user_units, dependent: :destroy
  has_many :units, through: :user_units
  has_many :tickets, dependent: :destroy

  # Associações de Colaborador (Escopo de Trabalho)
  # Usaremos 'responsabilidades' como a tabela intermediária
  has_many :responsabilidades, dependent: :destroy
  has_many :assigned_categories, through: :responsabilidades, source: :ticket_type
end
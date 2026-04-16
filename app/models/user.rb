class User < ApplicationRecord
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable
  
  enum :role, { morador: 0, colaborador: 1, admin: 2 }

  # Resident associations
  has_many :user_units, dependent: :destroy
  has_many :units, through: :user_units
  has_many :tickets, dependent: :destroy

  # Technician associations (Work scope)
  # Mudamos para 'responsibilities' (inglês), apontando para o model em português
  has_many :responsibilities, class_name: 'Responsabilidade', dependent: :destroy
  has_many :assigned_categories, through: :responsibilities, source: :ticket_type
end
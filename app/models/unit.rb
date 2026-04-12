class Unit < ApplicationRecord
  belongs_to :block
  
  # Adicione esta linha para o Rails reconhecer o método .users
  has_many :user_units, dependent: :destroy
  has_many :users, through: :user_units
  
  # Se você tiver chamados, adicione também:
  has_many :tickets, dependent: :destroy
end
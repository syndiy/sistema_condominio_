class TicketType < ApplicationRecord
  has_many :tickets, dependent: :destroy
  has_many :responsibilities, class_name: 'Responsabilidade', dependent: :destroy
  has_many :users, through: :responsibilities

  validates :title, presence: true
end
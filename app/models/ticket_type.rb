class TicketType < ApplicationRecord
  has_many :tickets
  has_many :responsibilities
  has_many :users, through: :responsibilities
end
class TicketType < ApplicationRecord
  has_many :tickets
  has_many :responsibilities
  has_many :users, through: :responsibilities
  has_many :user_ticket_types
has_many :technicians, through: :user_ticket_types, source: :user
end
class Unit < ApplicationRecord
  belongs_to :block
  has_many :user_units
  has_many :users, through: :user_units
  has_many :tickets
  before_destroy :check_for_dependencies

  private

  def check_for_dependencies
    if users.any?
      errors.add(:base, "Não é possível excluir uma unidade que possui moradores vinculados.")
      throw :abort
    end

    if tickets.any?
      errors.add(:base, "Não é possível excluir uma unidade que possui chamados registrados.")
      throw :abort
    end
  end
end
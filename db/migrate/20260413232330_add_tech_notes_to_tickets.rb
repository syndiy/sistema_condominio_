class AddTechNotesToTickets < ActiveRecord::Migration[8.1]
  def change
    add_column :tickets, :tech_notes, :text
  end
end

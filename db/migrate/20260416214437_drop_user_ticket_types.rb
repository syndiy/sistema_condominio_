class DropUserTicketTypes < ActiveRecord::Migration[8.1]
  def change
    drop_table :user_ticket_types do |t|
      t.bigint "ticket_type_id", null: false
      t.bigint "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
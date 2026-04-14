class CreateResponsabilidades < ActiveRecord::Migration[8.1]
  def change
    create_table :responsabilidades do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end

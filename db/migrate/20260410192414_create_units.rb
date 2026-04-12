class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.references :block, null: false, foreign_key: true
      t.integer :floor
      t.string :number

      t.timestamps
    end
  end
end

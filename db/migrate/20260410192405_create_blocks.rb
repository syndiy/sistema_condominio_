class CreateBlocks < ActiveRecord::Migration[8.1]
  def change
    create_table :blocks do |t|
      t.string :identification
      t.integer :floors_count
      t.integer :apartments_per_floor

      t.timestamps
    end
  end
end

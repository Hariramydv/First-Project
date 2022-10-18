class CreateProperties < ActiveRecord::Migration[7.0]
  def change
    create_table :properties do |t|
      
      t.string :appartment_name
      t.string :construction_status
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :price
      t.string :listed_by
      t.string :parking
      t.string :garden
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end

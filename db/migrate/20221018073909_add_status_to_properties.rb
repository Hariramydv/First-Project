class AddStatusToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :status, :string, default: 'active', null: false
  end
end

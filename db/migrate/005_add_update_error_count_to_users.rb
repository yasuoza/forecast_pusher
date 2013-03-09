class AddUpdateErrorCountToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.integer :update_error_count, null: false, default: 0
    end
  end
end

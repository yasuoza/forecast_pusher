class AddOnlyNextColumnToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :next_only, default: false
    end
  end
end

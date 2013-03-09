class AddIndexToPoints < ActiveRecord::Migration
  def change
    add_index :points, :pref_id
    add_index :points, [:pref_id, :area_id]
  end
end

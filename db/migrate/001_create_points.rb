class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.integer :area_id
      t.string :area_name
      t.integer :pref_id
      t.string :pref_name
      t.timestamps
    end
  end

  def self.down
    drop_table :points
  end
end

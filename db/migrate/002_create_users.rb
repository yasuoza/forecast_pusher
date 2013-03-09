class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :screen_name
      t.integer :pref_id
      t.string :area_id
      t.string :access_token
      t.string :access_token_secret
      t.string :name
      t.integer :next_info
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

require 'mysql2'

namespace :db do
  desc 'update users table scheme'
  task :update_users_scheme do
    database_host     = 'localhost'
    database          = 'forecast_pusher_next'
    old_database      = 'forecast_pusher_old'
    database_user     = 'forecast_pusher'
    database_password = 'forecast_pusher'

    new_database = Mysql2::Client.new(host:     database_host,
                                      database: database,
                                      username: database_user,
                                      password: database_password)

    old_database = Mysql2::Client.new(host:     database_host,
                                      database: old_database,
                                      username: database_user,
                                      password: database_password)

    new_place_hash = {}
    new_database.query('SELECT * from points').each(symbolize_keys: true).map do |point|
      new_place_hash.merge!(Hash[point[:pref_name].to_s + point[:area_name].to_s,  [point[:pref_id],  point[:area_id]]])
    end

    old_place_hash = {}
    old_database.query('select * from points').each(symbolize_keys: true).map do |point|
      old_place_hash.merge!(Hash[point[:pref_name].to_s + point[:area_name].to_s,  [point[:pref_id],  point[:area_id]]])
    end

    place_migrate_table = {}
    old_place_hash.each do |key,  val|
      place_migrate_table.merge!(Hash[val,  new_place_hash[key]])
    end

    # Update users row data
    old_database.query('SELECT * from users').each(symbolize_keys: true).each do |user|
      next if user[:pref_id].to_s.empty?

      user_area_data = [user[:pref_id], user[:area_id]]
      new_area_data = place_migrate_table[user_area_data]
      new_pref_id, new_area_id = new_area_data
      update_query = "UPDATE users SET pref_id = #{new_pref_id}, area_id = #{new_area_id} where id = #{user[:id]}"
      p update_query
      old_database.query(update_query)
    end
  end
end

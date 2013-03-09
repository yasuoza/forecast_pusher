require 'json'
require 'mysql2'

def load_jsons
  jsons = Dir[File.expand_path('../../jsons/*.json', __FILE__)].sort do |a, b|
    a.match(/(\d+)/)[1].to_i -  b.match(/(\d+)/)[1].to_i
  end
end

client = Mysql2::Client.new(host:     @database_host,
                            database: @database,
                            username: @database_user,
                            password: @database_password)

jsons = @jsons || load_jsons

jsons.each_with_index do |json, pref_id|
  pref_data = JSON.parse(File.open(json).read)
  pref_name = pref_data['pref']

  p "#{pref_id}: #{pref_name}"
  client.query("INSERT INTO points (pref_id, pref_name) VALUES ('#{pref_id}', '#{pref_name}')")

  pref_data['areas'].each_with_index do |area, area_id|
    area_name = area['area']
    p "#{area_id}: #{area_name}"
    client.query("INSERT INTO points (area_id, area_name, pref_id, pref_name) VALUES ('#{area_id}', '#{area_name}', '#{pref_id}', '#{pref_name}')")
  end
end

class User < ActiveRecord::Base

  scope :today_update_users_of, ->(pref_id){ User.where(pref_id: pref_id, next_only: false) }
  scope :next_update_users_of,  ->(pref_id){ User.where(pref_id: pref_id, next_info: true) }

  class << self

    def find_or_create_from_auth(auth)
      where(screen_name: auth[:info][:nickname]).first_or_create do |user|
        user.access_token = auth[:credentials][:token]
        user.access_token_secret = auth[:credentials][:secret]
        user.name = auth[:info][:name]
      end
    end

  end

  def has_point?
    !!self.point
  end

  def point
    pref_id = self.pref_id
    return nil unless pref_id
    Point.where(pref_id: self.pref_id, area_id: self.area_id).first
  end

end

module ForcastTweeter
  extend self

  PREF_RANGE = (0..46)

  def update_status!(option={next_update: false})
    @cache = {}

    is_next_update = option[:next_update]

    case is_next_update
    when false
      users_method_sym = :today_update_users_of
      blk = lambda { |user, status|
        Twitter::REST::Client.new { |config|
          config.consumer_key = defaults[:consumer_key]
          config.consumer_secret = defaults[:consumer_secret]
          config.access_token = user.access_token
          config.access_token_secret = user.access_token_secret
        }.update(status)
      }
    else
      users_method_sym = :next_update_users_of
      blk = lambda { |user, status|
       Twitter::REST::Client.new(defaults).update(status)
      }
    end

    errors = []
    update_record_queue = Queue.new

    PREF_RANGE.each do |pref_id|
      threads = []
      User.send(users_method_sym, pref_id).each do |user|
        status = status_for(user, is_next_update)
        threads << Thread.new do
          begin
            blk.call(user, status)
          rescue => ex
            if user.update_error_count >= 5
              update_record_queue << lambda {
                user.update_attributes!(pref_id: nil, area_id: nil, update_error_count: 0)
              }
              errors << exception_of(ex, status)
            else
              update_record_queue << lambda { user.increment(:update_error_count).save }
              puts exception_of(ex, status)
            end
          end
        end
      end
      threads.each(&:join)
    end

    until update_record_queue.empty?
      update_record_queue.pop.call
    end

    unless errors.empty?
      raise errors.join("\n")
    end
  end

  private
    def status_for(user, next_update = false)
      pref_id, area_id = user.pref_id.to_i, user.area_id.to_i

      status =
        @cache[[pref_id, area_id, next_update]] ||= UpdateTextBuilder.build(pref_id,
                                                                            area_id,
                                                                            next_update)

      "@#{user.screen_name} #{status}".truncate(140)
    end

    def exception_of(exception, status)
      %Q(kind:rake_error\ttask:tweet:next:forecast\tdate:#{Time.now}\terror:#{exception.inspect}\tstatus:#{status})
    end
end

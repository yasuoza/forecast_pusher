require 'active_support/core_ext'

namespace :tweet do

  desc "Tweet today's forecast"
  task forecast: :environment do
    ForcastTweeter.update_status!
  end

  namespace :next do

    desc "Tweet tomorrow's forecast"
    task forecast: :environment do
      ForcastTweeter.update_status! next_update: true
    end

  end
end

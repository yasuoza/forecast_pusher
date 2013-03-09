namespace :coffee do
  desc 'Generate register_form core code'
  task :generate_register_form => :environment do
    points = Point.all
    points.each do |point|
      if point.area_id.nil?
       print %Q(when '#{point.pref_id}'\n)

      else
        print %Q(  sel_area.append('<option value="#{point.area_id}">#{point.area_name}</option>')\n)
      end
    end
  end
end

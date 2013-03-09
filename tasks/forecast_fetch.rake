namespace :forecast do

  desc 'fetch forecast data'
  task :fetch do
    Dir.chdir(File.join(__dir__, 'data')) do
      puts "moving to #{Dir.pwd}"
      system 'npm install'
      system '`npm bin`/cake -o jsons forecast:fetch'
    end
  end

end

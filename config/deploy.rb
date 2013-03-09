require 'capistrano_colors'
require 'capistrano-rbenv'
require 'bundler/capistrano'
require 'capistrano-unicorn'

#                                                                        Config
# ==============================================================================
set :user, 'yasu'

set :use_sudo, false
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :git_enable_submodules, true

server 'yasuoza.com', :app, :web, :db, :primary => true
set :deploy_to,  "/home/#{user}/Projects/Padrino/forecast_pusher"

set :repository, 'git@source.yasuoza.com:yasuharu.ozaki/forecast_pusher.git'
set :branch, 'master'

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

set :app_env, 'development'

#                                                                        Deploy
# ==============================================================================
namespace :deploy do
  task :migrate, role: :db, only: {primary: true} do
    rake = fetch(:rake, 'rake')
    padrino_env = fetch(:padrino_env, 'production')

    run "cd #{current_path} && #{rake} PADRINO_ENV=#{padrino_env} ar:migrate"
  end

  # capistrano-unicorn
  after "deploy:restart", "unicorn:restart"
end

set :runner, "scottmotte"
set :use_sudo, false

# =============================================================================
# CUSTOM OPTIONS
# =============================================================================
set :user, "scottmotte"
set :application, "wiki.mottemanagers.com"
set :domain, "wiki.mottemanagers.com"

role :app, domain, :cron => true
role :web, domain
role :db,  domain, :primary => true

# =============================================================================
# DATABASE OPTIONS
# =============================================================================
set :migrate_env, "MERB_ENV=production"

# =============================================================================
# DEPLOY TO
# =============================================================================
set :deploy_to, "/home/#{user}/apps/#{application}"

# # =============================================================================
# # REPOSITORY
# # =============================================================================
set :scm, "git"
set :repository,  "git@github.com:scottmotte/#{application}.git"
set :branch, "master"
set :deploy_via, :remote_cache

# =============================================================================
# SSH OPTIONS
# =============================================================================
default_run_options[:pty] = true
ssh_options[:paranoid] = false
ssh_options[:keys] = %w(/Users/scottmotte/.ssh/id_rsa)
ssh_options[:port] = 1984

# =============================================================================
# SINATRA STUFF
# =============================================================================
set :stage, :production
set :app_server, :passenger

# =============================================================================
# RAKE TASKS & OTHER SERVER TASKS
# =============================================================================
namespace :deploy do
  # override Rails related callbacks
  task :finalize_update do
  end
 
  desc "Overwrite migrate with datamapper migration"
  task :migrate do
  end
  
  desc 'restart app'
  task :restart do
    run "mkdir -p #{latest_release}/tmp; touch #{latest_release}/tmp/restart.txt"
  end
  
  desc 'restart nginx'
  task :restart_nginx, :roles => :web do
    sudo '/etc/init.d/nginx stop'
    sudo '/etc/init.d/nginx start'
  end
  
  desc "Install dependency gems"
  task :dependency_gems do
    run 'sudo gem install sinatra'
    run 'sudo gem install maruku'
    run 'sudo gem install haml'
    run 'sudo gem install couchrest'
    run 'sudo gem install json'
  end  
end

after "deploy:update_code", "deploy:cleanup"
after "deploy:cleanup", "deploy:dependency_gems"
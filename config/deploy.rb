# =============================================================================
# ROLES
# =============================================================================
role :app, "174.142.75.247"
role :web, "174.142.75.247"
role :db,  "174.142.75.247", :primary => true

# =============================================================================
# SETUP
# =============================================================================
set :user, 'scottmotte'
set :application, 'wiki.mottemanagers.com'

# =============================================================================
# DEPLOY TO
# =============================================================================
set :deploy_to, "/home/scottmotte/apps/wiki.mottemanagers.com"
set :scm_verbose, true
set :use_sudo, false

# # =============================================================================
# # REPOSITORY
# # =============================================================================
set :scm, "git"
set :repository,  "git@github.com:scottmotte/wiki.mottemanagers.com.git"
set :branch, "master"
set :deploy_via, :remote_cache

# =============================================================================
# SSH OPTIONS
# =============================================================================
default_run_options[:pty] = true
ssh_options[:paranoid] = false

# =============================================================================
# RAKE TASKS & OTHER SERVER TASKS
# =============================================================================
namespace :deploy do
  task :install_gems_on_server do
    sudo "sh -c 'cd #{latest_release} && ruby lib/install_gems.rb'"
  end
  
  desc "Custom restart task for unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do    
    sudo "sh -c 'cd #{latest_release} && /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill load config/unicorn.pill'"
    sudo "sh -c 'cd #{latest_release} && /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill mottemanagerswiki-production restart production'"
  end

  desc "Custom start task for unicorn"
  task :start, :roles => :app do
    sudo "sh -c 'cd #{latest_release} && /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill mottemanagerswiki-production start production'"
  end

  desc "Custom stop task for unicorn"
  task :stop, :roles => :app do
    sudo "sh -c 'cd #{latest_release} && /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill mottemanagerswiki-production stop production'"
  end
end

after 'deploy:update_code', 'deploy:install_gems_on_server', 'deploy:cleanup'
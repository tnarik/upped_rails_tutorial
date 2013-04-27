require 'bundler/capistrano'

set :application, "hostedupped"

set :scm, :git
set :repository,  "git@github.com:tnarik/upped_rails_tutorial.git"
set :scm_passphrase, ""

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "nonmachinepeople.net"                          # Your HTTP server, Apache/etc
role :app, "nonmachinepeople.net"                          # This may be the same as your `Web` server
role :db,  "nonmachinepeople.net", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/tnarik/ror/#{application}"
set :use_sudo, false

set :user, "tnarik"  # The server's user for deploys
set :ssh_options, { :forward_agent => true }
set :git_shallow_clone, 1


## RVM and capistrano
set :rvm_require_role, :app
set :rvm_ruby_string, :local               # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, OR:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset
require "rvm/capistrano"

namespace :rvm do
  task :trust_rvmrc do
    p "rvm rvmrc trust #{current_release}"
    run "rvm rvmrc trust #{current_release}"
  end
end

before "deploy:restart", "rvm:trust_rvmrc"
before "deploy:start", "rvm:trust_rvmrc"


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end